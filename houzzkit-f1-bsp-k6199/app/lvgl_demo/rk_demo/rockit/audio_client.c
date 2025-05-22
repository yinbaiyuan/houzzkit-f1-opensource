#include <arpa/inet.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "audio_in.h"
#include "audio_out.h"
#include "audio_server.h"

#include "rk_defines.h"
#include "rk_debug.h"
#include "rk_mpi_sys.h"

struct audio_client
{
    int fd;
    int state;
    pthread_t tid;
};

static int ai_write(void *arg, char *buf, int len)
{
    struct audio_client *client = (struct audio_client *)arg;

    if (!buf)
    {
        RK_LOGE("buf is NULL");
        return 0;
    }

    int num = write(client->fd, buf, len);

    return num;
}

static void *do_cap(void *arg)
{
    struct audio_client *client = (struct audio_client *)arg;
    int result = 0;

    result = ai_init();
    if (result != 0)
    {
        RK_LOGE("ai init fail", result);
        client->state = STATE_ERROR;
        goto end;
    }

    client->state = STATE_RUNNING;
    while (client->state == STATE_RUNNING)
    {
        if (ai_fetch(ai_write, client) == -1)
            break;
    }
    ai_deinit();

    client->state = STATE_IDLE;
end:
    close(client->fd);
    client->fd = -1;

    return NULL;
}

int audio_client_state(void *arg)
{
    struct audio_client *client = (struct audio_client *)arg;

    if (!client)
        return STATE_IDLE;

    return client->state;
}

int audio_client_del(void *arg)
{
    struct audio_client *client = (struct audio_client *)arg;

    if (!client)
    {
        printf("%s null ptr\n", __func__);
        return -1;
    }

    client->state = STATE_EXIT;
    if (client->tid) {
        pthread_join(client->tid, RK_NULL);
        client->tid = 0;
    }

    free(client);

    return 0;
}

void *audio_client_new(char *ip)
{
    struct audio_client *client;
    struct sockaddr_in serveraddr;
    int fd;
    int ret;

    client = calloc(1, sizeof(*client));
    if (!client)
    {
        printf("audio client calloc failed %d\n", sizeof(*client));
        return NULL;
    }

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0)
    {
        printf("socket error\n");
        goto fd_err;
    }

    client->fd = fd;

    printf("connect to [%s]\n", ip);
    serveraddr.sin_family = AF_INET;
    inet_pton(AF_INET, ip, &serveraddr.sin_addr.s_addr);
    serveraddr.sin_port = htons(9999);
    ret = connect(fd, (struct sockaddr *)&serveraddr, sizeof(serveraddr));

    if (ret < 0)
    {
        printf("connect error\n");
        goto conn_err;
    }

    ret = pthread_create(&client->tid, NULL, do_cap, client);
    if (ret < 0)
    {
        printf("pthread error\n");
        goto conn_err;
    }

    return client;

conn_err:
    close(fd);
fd_err:
    free(client);

    return NULL;
}

