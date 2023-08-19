# Bubble Sort

This example implements a bubble sort algorithm.

A python version:

```python
def swap(vec: List[int], idx1: int, idx2: int) -> None:
    aux = vec[idx1]
    vec[idx1] = vec[idx2]
    vec[idx2] = aux

def bubble_sort(vec: List[int]) -> None:
    for idx1 in range(len(vec)):
        for idx2 in range(idx1 + 1, len(vec)):
            if vec[idx1] > vec[idx2]:
                swap(vec, idx1, idx2)
```

Given the following algorithm, we need to implement the following tasks:

1. Iteration over all indexes (idx1)
2. Iteration from idx2 to end starting on idx1
3. Swap elements if condition vec[idx1] > vec[idx2]

Thinking on the HDL implementation, we have the following requirements/constraints:

1. Two counters are required idx1 and idx2.
2. Only one element can be read at a time from the Block RAM.
   Therefore, two cycles are needed to read idx1 and idx2.
3. Only one element can be writen at time to the Block RAM:
   Therefore, two cycles are needed to perfom the swap.
   In addition, idx1 and idx2 must be present in the same block.

Base on these requirements we can design the following states:

1. STATE_IDLE: rdy: '0'
2. STATE_PREPARE: idx1 = 0, idx2 = idx1 + 1
3. STATE_READ_1: read idx1 to val1
4. STATE_READ_2: read idx2 to val2
5. STATE_COMPARE: 
    - if val1 > val2 goto SWAP_1 
    - else (increment idx2, increment idx1 when idx1) and goto STATE_READ_1
    - if idx1 == 255 goto STATE_END
5. STATE_SWAP_1: write val2 in idx1
6. STATE_SWAP_2: write val2 in idx1
7. STATE_RDY: rdy = '1'
