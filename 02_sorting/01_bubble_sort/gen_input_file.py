import random
from typing import List

NUM_ROWS = 256

arr = list()

print("Input Array:")
with open("input_file.txt", "w") as f:
    for idx in range(NUM_ROWS):

        val = random.randint(0, 255)
        # val = idx  # best case
        # val = 255 - idx  # worst case
        f.write(f"{val:08b}\n")
        arr.append(val)

print(arr)


# buble sort implementation

def swap(vec: List[int], idx1: int, idx2: int) -> None:
    aux = vec[idx1]
    vec[idx1] = vec[idx2]
    vec[idx2] = aux
    # print(f"swap({idx1}, {idx2})")


def bubble_sort(vec: List[int]) -> None:
    for idx1 in range(len(vec)):
        for idx2 in range(idx1 + 1, len(vec)):
            if vec[idx1] > vec[idx2]:
                swap(vec, idx1, idx2)


bubble_sort(arr)
print("Output Array:")
print(arr)
print("-vhdl-")
