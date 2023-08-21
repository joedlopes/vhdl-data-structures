import random
from typing import List, Tuple
import time

NUM_ROWS = 256

arr = list()

for idx in range(NUM_ROWS):
    val = random.randint(0, 255)
    # val = idx  # best case
    # val = 255 - idx  # worst case
    arr.append(val)

arr = sorted(arr)
print("Input Array:")

with open("input_file.txt", "w") as f:
    for val in arr:
        f.write(f"{val:08b}\n")


def linear_search(
    bram: List[int],
    idx_left: int,
    idx_right: int,
    target: int,
) -> Tuple[int, int]:

    # check target is in the range
    if target <= bram[idx_left]:
        return idx_left, bram[idx_left]
    if target > bram[idx_right]:
        return idx_right, bram[idx_right]

    # equal
    idx: int = idx_left
    while idx < idx_right:
        if bram[idx] == target:  # first equal
            return idx, bram[idx]
        # print(bram[idx], target, bram[idx + 1])
        if bram[idx] < target and bram[idx + 1] > target:  # value between
            if (target - bram[idx]) <= (bram[idx + 1] - target):
                return idx, bram[idx]
            else:
                return idx + 1, bram[idx + 1]

        idx += 1

    return idx - 1, bram[idx - 1]


def binary_search(
    bram: List[int],
    idx_left: int,
    idx_right: int,
    target: int,
) -> Tuple[int, int]:
    idx_middle: int = 0
    cycles: int = 0

    if target <= bram[0]:
        print("LOW RANGE")
        return 0, bram[0]
    elif target > bram[len(bram)-1]:
        print("HIGH RANGE")
        return len(bram)-1, bram[len(bram)-1]

    while idx_left < idx_right - 2:

        idx_middle = (idx_left >> 1) + (idx_right >> 1)
        val_mid = bram[idx_middle]

        print(f"[{idx_left:02d}, {idx_right:02d}]", "idx_mid =", idx_middle,
              "val =", val_mid, "target =", target)

        time.sleep(0.01)

        if target > val_mid:
            idx_left = idx_middle
            print("idx_left =", idx_left)

        elif target < val_mid:
            idx_right = idx_middle
            print("idx_right =", idx_right)
        else:
            print(f"!FOUND[{idx_left:03d}, {idx_middle:03d}, {idx_right:03d}]")
            idx_right = idx_middle

    print("OUT")
    # idx_middle = (idx_left >> 1) + (idx_right >> 1)
    if idx_middle == idx_left:
        idx_middle = idx_middle + 1
    elif idx_middle == idx_right:
        idx_middle = idx_middle - 1

    print(f"!rEND[{idx_left:03d}, {idx_middle:03d}, {idx_right:03d}]")
    print()

    # val_left = bram[idx_left]
    val_mid = bram[idx_middle]
    # val_right = bram[idx_right]
    
    if target < val_mid:
        idx_right = idx_middle
    else:
        idx_left = idx_middle

    print(f"!xEND[{idx_left:03d}, {idx_middle:03d}, {idx_right:03d}]")

    idx_min = idx_left
    idx_max = idx_right
    # idx_min = min(idx_left, min(idx_middle, idx_right))
    # idx_max = max(idx_left, max(idx_middle, idx_right))

    print("minmax", idx_min, idx_max)
    val_min = bram[idx_min]
    val_max = bram[idx_max]
    print("val", val_min, val_max)

    if val_min == target:
        idx_left = idx_min
    elif val_max == target:
        idx_left = idx_max
    else:
        A = target - val_min
        B = val_max - target

        if A <= B:
            idx_left = idx_min
        else:
            idx_left = idx_max

    return idx_left, bram[idx_left]


target = random.randint(0, 255)

if True:
    # target = 63
    # target = 252
    # arr = [8, 9, 26, 62, 62, 111, 111, 111, 111, 111, 111, 111, 189, 189, 252, 252]
    # arr = [3, 6, 32, 34, 41, 62, 64, 94, 103, 110, 111, 184, 191, 207, 214, 253]
    # arr = [18, 22, 27, 42, 42, 43, 78, 135, 160, 176, 182, 197, 216, 216, 237, 243]
    # arr = [17, 24, 29, 43, 91, 107, 130, 134, 139, 143, 144, 153, 153, 153, 220, 240]
    # arr = [7, 8, 13, 13, 39, 68, 78, 94, 99, 104, 105, 203, 217, 223, 232, 238]
    # arr = [8, 9, 26, 62, 62, 111, 111, 111, 111, 111, 111, 111, 189, 189, 221, 252]
    # arr = [15, 28, 31, 51, 63, 82, 90, 100, 116, 129, 191, 191, 197, 206, 232, 232]
    # target = 28
    # arr = [13, 21, 24, 32, 60, 71, 91, 129, 154, 184, 187, 213, 213, 215, 231, 248]
    print(", ".join([f"{x:03d}" for x in range(len(arr))]))
    print(", ".join([f"{x:03d}" for x in arr]))
else:
    print(arr)


# target = 3000
print("Target Value:", target)

idx_gt, val_gt = linear_search(arr, 0, len(arr)-1, target)

print("Expected Output:", )
idx_res = 0
idx_res, val_res = binary_search(arr, 0, len(arr)-1, target)

print(f"> val gt:  {arr[idx_gt]:03d}, idx: {idx_gt:03d}")
print(f"> val res: {val_res:03d}, idx: {idx_res:03d}")

if idx_res == idx_gt:
    print("PASSED!")
else:
    print()
    print("FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!FAIL!")
    print()

print("-vhdl-")
