# Binary Search

This example implements a binary search algorithm.

Given a Block RAM of 8bit address (0 to 255 values),
and a target value, the designed circuit should return
the closest index and value.

The main condition for the binary search is that the values
are already sorted.

As follows a basic implementation of the binary search algorith:

```python
def binary_search(
    bram: List[int],
    idx_left: int,
    idx_right: int,
    target: int,
) -> Tuple[int, int]:
    # state: - prepare
    idx_middle: int = idx_left

    # state: - read 0 
    if target <= bram[0]:
        return 0, bram[0]

    # state: - read n
    elif target > bram[len(bram)-1]:
        return len(bram)-1, bram[len(bram)-1]
    
    # state: run search
    while idx_left < idx_right - 2:
        # tick
        idx_middle = (idx_left >> 1) + (idx_right >> 1)
        val_mid = bram[idx_middle]

        # tick
        if target > val_mid:
            idx_left = idx_middle
        # elif target < val_mid:
        #     idx_right = idx_middle
        else:
            idx_right = idx_middle  # when equal, search for left most
    
    # when condition loop of run state is false
    if idx_middle == idx_left:
        idx_middle = idx_middle + 1
    elif idx_middle == idx_right:
        idx_middle = idx_middle - 1

    # tick: state - check middle
    val_mid = bram[idx_middle]
    if target < val_mid:
        idx_right = idx_middle
    else:
        idx_left = idx_middle

    # tick: check left
    val_min = bram[idx_left]
    if val_min == target:
        return idx_left, bram[idx_left]

    # tick: check right
    val_max = bram[idx_right]
    if val_max == target:
        idx_left = idx_right
        return idx_left, bram[idx_left]

    # tick: sub -> add one cycle to ensure timing
    A = target - val_min
    B = val_max - target

    # tick: check closest state
    if A > B:
        idx_left = idx_right

    # tick: ready state
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


