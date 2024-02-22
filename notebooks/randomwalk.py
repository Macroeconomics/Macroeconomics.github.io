#!/usr/bin/env python
# coding=utf-8
'''
My First script in Python

Author: Me
E-mail: me@me.com
Website: http://me.com
GitHub:  https://github.com/me
Date: Today

This code computes Random Walks and graphs them
'''

import numpy as np
import matplotlib.pyplot as plt

# The function
def randomwalk(x0, T, mu, sigma, seed=123456):
    '''This function computes and plots a random walk
    starting from x0 for T periods where shocks have distribution
    N(mu, sigma^2)
    '''
    if seed is not None:
        np.random.seed(seed)
    x = [x0]
    [x.append(x[-1] + np.random.normal(mu, sigma) ) for i in range(T)]
    plt.plot(x)
    plt.title('A simple random walk')
    plt.xlabel('Period')
    plt.ylabel('Variable')
    plt.show()
    return x
