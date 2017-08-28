# Numpy 

Python library adding support for large **homogeneous multi-dimensional arrays** and matrices, along with a large collection of high-level mathematical functions to operate on these arrays. 

* Numpy `ndarray` class for n-dimensional array
* Homogeneously typed (all elements have the same type)
* Numerical operations with ndarray run on full compiled code speed

```python
# recommended convention to import numpy
import numpy as np                 # with abbr. np
```

### Create & Shape

Dimensions are called **axes**, and the number of axes is **rank**

```python
# init. an array using a tuple or list
print(np.array((1,2,3,4,5)))
print(np.array([1,2,3,4,5]))         # [1 2 3 4 5]
# print omitted
# explicit type specification 
np.array((1,2),float)                # [ 1.  2.]
np.array([1,2],dtype=complex)        # [ 1.+0.j  2.+0.j]
# multiple dimensions
np.array(([1,2,3],[4,5,6],[7,8,9]))  # [[1 2 3] [4 5 6] [7 8 9]]
# initial with placeholder content
np.zeros((3,2))                      # [[ 0.  0.] [ 0.  0.] [ 0.  0.]]
np.ones((2,2,2))                     # [[[ 1.  1.] [ 1.  1.]] [[ 1.  1.] [ 1.  1.]]]
np.full((2,2),5)                     # [[5 5] [5 5]]
np.diag(np.array([1, 2, 3]))         # [[1 0 0] [0 2 0] [0 0 3]]
# create sequences of numbers with args. [start,]stop[,step] (cf. range)
np.arange(5)                         # [0 1 2 3 4]
np.arange(5,10)                      # [5 6 7 8 9]
np.arange(0,30,10)                   # [0 10 20]
# linearly spaced sequence
np.linspace(2,3,5)                   # [2. 2.25 2.5 2.75 3.]
# log spaced sequence 
np.logspace(0,1,5)                   # [1. 1.77827941 3.16227766 5.62341325 10. ]
np.random.rand(1,3)                  # [0.19544155  0.389351  0.09039669]
np.random.randint(0, 10, 5)          # [7 2 9 4 8]
```
```python
# print dimensions
np.array(((1,2),(3,4))).shape        # (2, 2)
# flatten
np.array(((1,2),(3,4))).flatten()
np.array(((1,2),(3,4))).ravel()      # [1 2 3 4]
# change dimensions
np.arange(6).reshape(2,3)            # [[0 1 2] [3 4 5]]
# transpose
np.zeros((2,3)).T                    # [[ 0.  0.] [ 0.  0.] [ 0.  0.]]
np.zeros((2,3)).transpose()
## stacking together
# vertical
np.vstack((np.zeros((2,2)),np.ones((2,2))))       # [[ 0.  0.] [ 0.  0.] [ 1.  1.] [ 1.  1.]]
# horizontal
np.hstack((np.zeros((2,2)),np.ones((2,2))))       # [[ 0.  0.  1.  1.] [ 0.  0.  1.  1.]]
np.hsplit(np.arange(10),2)                        # [[0 1 2 3 4] [5 6 7 8 9]]
```

### Operations

```python
np.array((10,20,30)) + np.array((1,2,3))                # [11 22 33]
np.array((10,20,30)) - np.array((1,2,3))                # [ 9 18 27]
np.array((2,4,8)) ** 2                                  # [ 4 16 64]                                             
np.array((2,4,8)) >= 4                                  # [False  True  True]
np.array((2,2,2)).sum()                                 # 6
np.array(((1,2),(4,5))).sum(axis=1)                     # [3 9]
np.array((1,2,3)).min()                                 # 1
np.array((1,2,3)).max()                                 # 3
np.array(((1,2),(4,5))).cumsum(axis=1)                  # [[1 3] [4 9]]
# vector products
np.array([1,2]).dot(np.array([3, 4]))                   # 11
# multiply a vector by a matrix
np.array([1,2]).dot(np.array([[3,4],[5,6]]))            # [13 16]
# multiply matrices
np.array([[1,2],[3,4]]).dot(np.array([[5,6],[7,8]]))    # [[19 22] [43 50]]
```

### Indexing, Slicing and Iterating

```python
a = np.array([1,2,3,4])            
# access elements in array a
a[3]                               # 4
a[-2]                              # 3 
a[:2]                              # [1 2] last index not included!
a[3] = 5                           # [1 2 3 5]
## multiple dimensions
a = np.array([[1,2,3],[4,5,6]], float)
# ':' all elements in dimension
a[1,:]                             # [ 4.  5.  6.]
a[:,2]                             # [ 3.  6.]
a = np.array([[1,2,3,4], [5,6,7,8], [9,10,11,12]])
a[:2,1:3]                          # [[2 3] [6 7]]
# reversing a sequence
np.arange(10)[::-1]                # [9 8 7 6 5 4 3 2 1 0]
# slice sequences [start:end:step]
np.arange(10)[2:9:3]               # [2 5 8]
np.arange(10)[::3]                 # [0 3 6 9]
# ... (dots) represent as many colons as needed to produce a complete indexing tuple
np.arange(12).reshape(3,4)[1,...]  # [4 5 6 7]
np.arange(12).reshape(3,4)[...,2]  # [2 6 10]
```

Slicing operation creates a **view** on the original array.

```python
a = np.arange(10)                  # [0 1 2 3 4 5 6 7 8 9] 
b = a[::2]                         # [0 2 4 6 8]
np.may_share_memory(a,b)           # True
c = b.copy() # force a copy
np.may_share_memory(a,c)           # False
```

### IO

Store data into a file:

```python
# write a binary file
>>> np.array([1,2,3],float).tofile('f.bin')
>>> !file f.bin
f.bin: dBase III DBT, next free block index 1
>>> print(np.fromfile('f.bin'))
[ 1.  2.  3.]
# write a clear text file
>>> np.savetxt('f.txt',np.array((1,2,3)))
>>> !cat f.txt
1.000000000000000000e+00
2.000000000000000000e+00
3.000000000000000000e+00
>>> print(np.loadtxt('f.txt'))
[ 1.  2.  3.]
```
