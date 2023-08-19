from typing import List


arr1 = None
with open("input_file.txt", "r") as fp:
    arr1 = [int(line.strip(), 2) for line in fp.readlines()]

arr2 = None
with open("output_file.txt", "r") as fp:
    arr2 = [int(line.strip(), 2) for line in fp.readlines()]


def test_true(name: str) -> None:
    def decorator(func):
        def wrapper(*args, **kwargs):
            result = func(*args, **kwargs)
            if result is True:
                print("[PASSED]", name)
            else:
                print("[FAIL]  ", name)
        return wrapper
    return decorator


@test_true("Sorted")
def check_sorted(arr1: List[int], arr2: List[int]) -> bool:
    arr1 = sorted(arr1)

    for idx, (a, b) in enumerate(zip(arr1, arr2)):
        if a != b:
            print(f"> Sorted Fail: element index {idx}")
            return False
    return True


@test_true("Array Length")
def check_size(vec1: List[int], vec2: List[int]) -> bool:
    return len(vec1) == len(vec2)


print("-- Output Array --")

print(arr2)

check_sorted(arr1, arr2)
check_size(arr1, arr2)

