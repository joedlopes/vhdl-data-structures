# Binary Search

This example implements a binary search algorithm.

Given a Block RAM of 8bit address (0 to 255 values),
and a target value, the designed circuit should return
the closest index and value.

The main condition for the binary search is that the values
are already sorted.

As follows a basic implementation of the binary search algorith:

```python
def binary_search(bram: List[int], 
                  idx_left: int,
                  idx_right: int,
                  target: int,
) -> Tuple[int, int]:
    idx_middle: int

    while idx_left != idx_right:
        idx_middle = (idx_right - idx_left) // 2
        
        if target < bram[idx_middle]:
            idx_right = idx_middle
        elif target > bram[idx_middle]:
            idx_left = idx_mid
        else:
            idx_left = idx_middle
            idx_right = idx_middle

    return idx_left, bram[idx_left]
```

From the following algorithm we can derive the following requirements:

1. Only one address of the array can be read at the time using the Block RAM.
   Therefore, to read the boundary values it is required two cycles in the
   beginning, and another two cycles in the end.

2. Integer division: the addresses must be divided to update boundaries.
   Here, we can shift the address bits to right:
   255 / 2 = 127   -->   0b11111111 >> 0b1 = 0b01111111
   128 / 2 = 63    -->   0b01111111 >> 0b1 = 0b00111111
   
   Therefore, we do not need a "divisor" unit to operate here.
   In VHDL we have the logical operator srl:
   "11111111" srl 1


Based on the previous requirements we can adapt the python code:

```python
def binary_search(bram: List[int], 
                  idx_left: int,
                  idx_right: int,
                  target: int,
) -> Tuple[int, int]:
    idx_middle: int

    while idx_left != idx_right:
        idx_middle = (idx_right - idx_left) >> 1
        idx_middle = (idx_right - idx_left) >> 1
        
        val_mid = bram[idx_middle]

        if target < val_mid:
            idx_right = idx_middle
        elif target > val_mid:
            idx_left = idx_mid
        else:
            idx_left = idx_middle
            idx_right = idx_middle

    return idx_left, bram[idx_left]
```

0  1   2   3   4   5   6   7
0, 30, 20, 20, 20, 50, 60, 70

t = 25
L = 0
R = 7
M = (0 + 7) // 2 = 3

