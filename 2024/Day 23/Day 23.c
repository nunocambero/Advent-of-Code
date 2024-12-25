#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int network[680][680]={0};
int ans[680];
int max=0;

int hash(char in[static 2]);
void out(int *in);
void maximal(int *r, int *p, int *x);
void intersect(int *a, int n);
void report(int *r);

int main (int argc, char * argv[])
{
    char *filename = "input.txt";
    long result=0;
    int part=1;
    char buf[16];
    int conns[680];
    int x,y,s,e;
    int r[6]={0};
    int p[680]={0};
    int z[6]={0};
    FILE * fp;
    if(argc > 1)
        part=atoi(argv[1]);
    if(argc > 2)
        filename=argv[2];
    if((fp = fopen (filename, "r"))==NULL)
    {
        printf("error opening file %s\n", filename);
        return 1;
    }
    while(fgets(buf, 16, fp) != NULL)
    {
         if(buf[0]=='\n')
             break;
         x=hash(strtok(buf,"-"));
         y=hash(strtok(NULL,"\n"));
         network[x][y]=network[y][x]=1;
         p[x]=p[y]=1;
    }
    if(part==1)
    {
        s=hash("ta");
        e=hash("ua");
        for(int i=s;i<e;i++)
        {
            x=0;
            memset(conns,0,sizeof(conns));
            for(int j=0;j<680;j++)
                if(network[i][j])
                    conns[x++]=j;
            for(y=0;y<x;y++)
                for(int j=y;j<x;j++)
                {
                    if(network[conns[y]][conns[j]])
                    {
                        result++;
                        network[conns[y]][i]=0;
                    }
                }
        }
        printf("%ld\n",result);
    }
    else
    {
        x=0;
        for(int i=0;i<680;i++)
        {
            if(p[i])
            {
                p[x++]=i;
                p[i]=0;
            }
        }
        maximal(r,p,z);
        out(ans);
    }
    return 0;
}

int hash(char *in)
{
    if(*in=='a'&&*(in+1)=='a')
        return 1;
    int ans=0;
    while(*in!='\0')
    {
        ans*=26;
        ans+=(*(in++))-97;
    }
    return ans;
}

void out(int *in)
{
    printf("%c%c",(*(in)/26)+97,(*(in)%26)+97);
    in++;
    while(*in)
    {
        printf(",%c%c",(*(in)/26)+97,(*(in)%26)+97);
        in++;
    }
    printf("\n");
}

void maximal(int *r, int *p, int *x)
{
    int j,k,l;
    for(j=0;p[j];j++);
    for(k=0;x[k];k++);
    for(l=0;r[l];l++);
    if((j==k)&&(j==0) || (j+l<max))
    {
        report(r);
        return;
    }
    int *r2=calloc(680,sizeof(int));
    memcpy(r2,r,l*sizeof(int));
    int *p2=calloc(680,sizeof(int));
    int *x2=calloc(680,sizeof(int));
    for(int i=0;p[i];i++)
    {
        if(network[p[0]][p[i]])
            continue;
        r2[l]=p[i];
        memcpy(p2,p+i,(j-i)*sizeof(int));
        intersect(p2,p[i]);
        memcpy(x2,x,k*sizeof(int));
        intersect(x2,p[i]);
        maximal(r2,p2,x2);
        x[k++]=p[i];
    }
}

void report(int *r)
{
    int x;
    for(x=0;r[x];x++);
    if(x>max)
    {
        max=x;
        memcpy(ans,r,max*sizeof(int));
    }
}

void intersect(int *a, int n)
{
    int x=0;
    for(int i=0;i<680;i++)
    {
        if(!network[a[i]][n])
        {
            a[i]=0;
            continue;
        }
        if(x==i)
            x++;
        else
        {
            a[x++]=a[i];
            a[i]=0;
        }
    }
}