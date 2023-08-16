NUM_ROWS = 256
with open("input_file.txt", "w") as f:
    for idx in range(NUM_ROWS):

        # if idx != 25:
        #     idx = 10
        # else:
        #     idx = 200
        # idx = min(79, idx)
        # print(idx)
        f.write(f"{idx:08b}\n")
