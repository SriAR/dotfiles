// C program to illustrate
// fgets()
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define MAX 2048
#define RED "196"
#define LGR "47"
#define DGR "29"
#define YEL "226"
#define ORN "202"
#define DBL "239"
#define PNK "206"
#define PRP "201"
#define DPR "129"
#define LBL "51"
#define COLOUR_PRINTER(colour, string) "\e[38;5;" colour "m" string "\e[0m"

bool prefix(const char *pre, const char *str);
char *colour(const char *col, const char *str);
int pretty_print(char direction);

int main(int argc, char** argv) {
    if(argc > 1) {
    /* The argument is 0 if LOCAL to SERVER, and 1 if SERVER to LOCAL */
        pretty_print(argv[1][0]);
    }
    else {
        pretty_print('2');
    }

    return 0;
}

int pretty_print(char direction)
{
    char target[MAX]="";
    char targetColour[20]="";
    switch(direction) {
        case '0':
            strcat(target,"SERVER");
            strcat(targetColour,"yel");
            break;
        case '1':
            strcat(target,"SYSTEM");
            strcat(targetColour,"lgr");
            break;
        default:
            strcat(target,"TARGET");
            strcat(targetColour,"lbl");
            break;
    }

    printf("%s\n","\e[0m");

	char buf[MAX];
	while(fgets(buf, MAX, stdin)) {
        switch(buf[0])
        {
            case '<':
                printf("%s ",colour("yel","SERVER"));
                break;
            case '>':
                printf("%s ",colour("lgr","SYSTEM"));
                break;
            case '*':
                printf("%s ",colour(targetColour,target));
                break;
            case 'c':
                printf("%s ",colour(targetColour,target));
                break;
            case '.':
                break;
            default:
                printf("%c",buf[0]);
        }


        if(prefix("d+++++++++",&buf[1])) {
            printf("%s ",colour("dgr","NEW"));
        }
        else if(prefix("d..t......",&buf[1])) {
            continue;
        }
        else if(prefix("f+++++++++",&buf[1])) {
            printf("%s ",colour("orn","NEW"));
        }
        else if(buf[3]=='s') {
            printf("%s ",colour("pnk","SIZ"));
        }
        else if(buf[4]=='t') {
            printf("%s ",colour("prp","TIM"));
        }
        else if(prefix("deleting", &buf[1])) {
            printf("%s ",colour("red","DEL"));
        }
        else {
            printf("%.10s",&buf[1]);
        }

        printf("%s",&buf[12]);
    }
	return 0;
}

bool prefix(const char *pre, const char *str)
{
    return strncmp(pre, str, strlen(pre)) == 0;
}

char *colour(const char *col, const char *str) {
    char buf[MAX] = "\e[38;5;";
    if (strncmp(col,"red",3) == 0) {
        strcat(buf,"196m");
    }
    else if(strncmp(col,"lgr",3) == 0) {
        strcat(buf,"47m");
    }
    else if(strncmp(col,"dgr",3) == 0) {
        strcat(buf,"29m");
    }
    else if(strncmp(col,"yel",3) == 0) {
        strcat(buf,"226m");
    }
    else if(strncmp(col,"orn",3) == 0) {
        strcat(buf,"202m");
    }
    else if(strncmp(col,"dbl",3) == 0) {
        strcat(buf,"239m");
    }
    else if(strncmp(col,"pnk",3) == 0) {
        strcat(buf,"206m");
    }
    else if(strncmp(col,"prp",3) == 0) {
        strcat(buf,"201m");
    }
    else if(strncmp(col,"dpr",3) == 0) {
        strcat(buf,"129m");
    }
    else if(strncmp(col,"lbl",3) == 0) {
        strcat(buf,"51m");
    }

    strcat(buf,str);
    return strcat(buf,"\e[0m");
}
