/**
 * Copyright (c) 2011 ~ 2012 Deepin, Inc.
 *               2011 ~ 2012 snyh
 *
 * Author:      snyh <snyh@snyh.org>
 * Maintainer:  snyh <snyh@snyh.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 **/
#include "utils.h"
#include <glib.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>

#include <sys/socket.h>
#include <sys/un.h>

gboolean is_application_running(const char* path)
{
    int server_sockfd;
    socklen_t server_len;
    struct sockaddr_un server_addr;

    server_addr.sun_path[0] = '\0'; //make it be an name unix socket
    strcpy(server_addr.sun_path+1, path);
    server_addr.sun_family = AF_UNIX;
    server_len = 1 + strlen(path) + offsetof(struct sockaddr_un, sun_path);

    server_sockfd = socket(AF_UNIX, SOCK_STREAM, 0);

    if (0 == bind(server_sockfd, (struct sockaddr *)&server_addr, server_len)) {
        return FALSE;
    } else {
        return TRUE;
    }
}

char* shell_escape(const char* source)
{
    const unsigned char *p;
    char *dest;
    char *q;

    g_return_val_if_fail (source != NULL, NULL);

    p = (unsigned char *) source;
    q = dest = g_malloc (strlen (source) * 4 + 1);

    while (*p)
    {
        switch (*p)
        {
            case '\'':
                *q++ = '\\';
                *q++ = '\'';
                break;
            case '\\':
                *q++ = '\\';
                *q++ = '\\';
                break;
            case ' ':
                *q++ = '\\';
                *q++ = ' ';
                break;

            default:
                *q++ = *p;
        }
        p++;
    }
    *q = 0;
    return dest;
}


char* json_escape (const char *source)
{
    const unsigned char *p;
    char *dest;
    char *q;

    g_return_val_if_fail (source != NULL, NULL);

    p = (unsigned char *) source;
    q = dest = g_malloc (strlen (source) * 4 + 1);

    while (*p)
    {
        switch (*p)
        {
            case '\b':
                *q++ = '\\';
                *q++ = 'b';
                break;
            case '\f':
                *q++ = '\\';
                *q++ = 'f';
                break;
            case '\n':
                *q++ = '\\';
                *q++ = 'n';
                break;
            case '\r':
                *q++ = '\\';
                *q++ = 'r';
                break;
            case '\t':
                *q++ = '\\';
                *q++ = 't';
                break;
            case '\v':
                *q++ = '\\';
                *q++ = 'v';
                break;
            case '\\':
                *q++ = '\\';
                *q++ = '\\';
                break;
            case '"':
                *q++ = '\\';
                *q++ = '"';
                break;
            default:
                *q++ = *p;
        }
        p++;
    }
    *q = 0;
    return dest;
}

void log_to_file(const gchar* log_domain, GLogLevelFlags log_level, const gchar* message, char* app_name)
{
    char* log_file_path = g_strdup_printf("/tmp/%s.log", app_name);
    FILE *logfile = fopen(log_file_path, "a");
    g_free(log_file_path);
    if (logfile == NULL) {
    }
    fprintf(logfile, "%s\n", message);
    fclose(logfile);

    g_log_default_handler(log_domain, log_level, message, NULL);
}

char* gen_id(const char* seed)
{
    return g_compute_checksum_for_string(G_CHECKSUM_MD5, seed, strlen(seed));
}

void run_command(const char* cmd)
{
    g_spawn_command_line_async(cmd, NULL);
}

void run_command1(const char* cmd, const char* p1)
{
    char* e_p = shell_escape(p1);
    char* e_cmd = g_strdup_printf("%s %s\n", cmd, e_p);
    g_free(e_p);

    g_spawn_command_line_async(e_cmd, NULL);
    g_free(e_cmd);
}
void run_command2(const char* cmd, const char* p1, const char* p2)
{
    char* e_p1 = shell_escape(p1);
    char* e_p2 = shell_escape(p2);
    char* e_cmd = g_strdup_printf("%s %s %s\n", cmd, e_p1, e_p2);
    g_free(e_p1);
    g_free(e_p2);

    g_spawn_command_line_async(e_cmd, NULL);
    g_free(e_cmd);
}

#include "i18n.h"
void init_i18n()
{
    setlocale(LC_MESSAGES, "");
    textdomain("DDE");
}


#include <unistd.h>
#include <fcntl.h>
char* get_name_by_pid(int pid)
{
#define LEN 1024
    char content[LEN];

    char* path = g_strdup_printf("/proc/%d/cmdline", pid);
    int fd = open(path, O_RDONLY);
    g_free(path);

    if (fd == -1) {
        return NULL;
    } else {
        read(fd, content, LEN);
        close(fd);
    }
    for (int i=0; i<LEN; i++) {
        if (content[i] == ' ') {
            content[i] = '\0';
            break;
        }
    }


    return g_path_get_basename(content);
}
