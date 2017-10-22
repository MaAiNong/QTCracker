//
//  NPCommonAlgorithm.m
//  CannyDemo
//
//  Created by Hydra on 15/8/12.
//  Copyright (c) 2015年 Hydra. All rights reserved.
//

#import "NPCommonAlgorithm.h"

void swap(long *x,long *y)
{
    long temp;
    temp = *x;
    *x = *y;
    *y = temp;
}

unsigned long choose_pivot(unsigned long i,unsigned long j )
{
    return((i+j) /2);
}

void q_sort(long list[],unsigned long m,unsigned long n)
{
    long key,i,j,k;
    if( m < n)
    {
        k = choose_pivot(m,n);
        swap(&list[m],&list[k]);
        key = list[m];
        i = m+1;
        j = n;
        while(i <= j)
        {
            while((i <= n) && (list[i] <= key))
                i++;
            while((j >= m) && (list[j] > key))
                j--;
            if( i < j)
                swap(&list[i],&list[j]);
        }
        // 交换两个元素的位置
        swap(&list[m],&list[j]);
        // 递归地对较小的数据序列进行排序
        
        q_sort(list,m,j-1);
        q_sort(list,j+1,n);
    }
}


unsigned long greatest_common_divisor(long a, long b) {
    long c;
    a=labs(a);
    b=labs(b);
    c=a%b;
    while( c!=0 )
    {
        a=b;
        b=c;
        c=a%b;
    }
    return b;
}

