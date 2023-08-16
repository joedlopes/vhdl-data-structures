NUM_ROWS = 256
with open("input_file.txt", "w") as f:
    for idx in range(NUM_ROWS):
        idx = 255 - idx
        # print(idx)
        f.write(f"{idx:08b}\n")
