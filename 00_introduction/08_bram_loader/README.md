# BRAM Initialization

In this example, we initialize a Block RAM (BRAM) with data from a text file (input_file.txt).
Later, in a second step, we read the BRAM and save the data to a text (output_file.txt).


First we generate the input_file.txt using the following script:

```bash
python3 gen_input_file.py
```

It will generate the input_file.txt to be used as basis, 
you may change the generator according to your needs.



## References

The Finite State Machine was developed based on the Professor Volnei Pedroni's
book: Circuit Design with VHDL (Chapter 11.2, page 279).
