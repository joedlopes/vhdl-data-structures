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

# arr = [0, 0, 5, 5, 7, 9, 10, 10, 11, 12, 12, 13, 20, 21, 22, 26, 27, 28, 28, 29, 31, 32, 33, 33, 34, 35, 37, 39, 39, 39, 39, 39, 40, 40, 44, 44, 45, 45, 50, 50, 51, 53, 54, 55, 57, 60, 61, 61, 64, 64, 64, 66, 67, 68, 70, 70, 72, 72, 74, 74, 75, 75, 78, 78, 79, 80, 82, 87, 88, 89, 90, 90, 90, 90, 92, 94, 94, 95, 97, 99, 99, 100, 101, 102, 103, 104, 104, 105, 105, 105, 105, 106, 107, 107, 108, 109, 110, 110, 111, 112, 112, 114, 114, 115, 115, 115, 117, 117, 117, 117, 119, 119, 119, 120, 120, 121, 121, 123, 124, 124, 126, 127, 128, 128, 129, 130, 133, 136, 138, 138, 138, 139, 140, 140, 141, 142, 143, 143, 143, 146, 150, 150, 150, 153, 154, 154, 156, 158, 158, 159, 159, 159, 160, 162, 164, 164, 164, 165, 166, 167, 168, 171, 171, 173, 173, 174, 174, 175, 176, 178, 179, 179, 180, 180, 181, 184, 185, 185, 185, 186, 187, 188, 188, 190, 191, 192, 192, 193, 193, 194, 194, 195, 196, 198, 198, 199, 199, 200, 200, 201, 202, 203, 204, 204, 204, 206, 207, 208, 208, 208, 209, 209, 210, 211, 211, 212, 214, 216, 218, 219, 219, 219, 219, 219, 220, 223, 224, 224, 225, 225, 226, 227, 229, 229, 229, 230, 231, 231, 234, 235, 235, 242, 243, 245, 246, 249, 250, 251, 251, 251, 251, 252, 252, 253, 253, 255]

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

    if target <= bram[0]:
        print("LOW RANGE")
        return 0, bram[0]
    elif target > bram[len(bram)-1]:
        print("HIGH RANGE")
        return len(bram)-1, bram[len(bram)-1]

    # while idx_left < idx_right - 2:

    while idx_right - idx_left > 2:
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
    if idx_middle == idx_left:
        idx_middle = idx_middle + 1
    elif idx_middle == idx_right:
        idx_middle = idx_middle - 1

    print(f"!rEND[{idx_left:03d}, {idx_middle:03d}, {idx_right:03d}]")
    print()
    val_mid = bram[idx_middle]

    if target < val_mid:
        idx_right = idx_middle
    else:
        idx_left = idx_middle

    print(f"!xEND[{idx_left:03d}, {idx_middle:03d}, {idx_right:03d}]")

    val_min = bram[idx_left]
    if val_min == target:
        return idx_left, bram[idx_left]

    val_max = bram[idx_right]
    if val_max == target:
        idx_left = idx_right
        return idx_left, bram[idx_left]

    print("val", val_min, val_max)

    A = target - val_min
    B = val_max - target

    if A > B:
        idx_left = idx_right

    return idx_left, bram[idx_left]


target = random.randint(0, 255)
target = 33
if False:
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
