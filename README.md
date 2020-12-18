# timemanagement-hs

Aggregates times in a logfile. See also [timelogger](https://github.com/godrin/timelogger)

## Install / Usage

Requires haskell build tool like `stack` or `cabal`, alternatively
`runhaskell`.


```
# Install e.g.
stack install

# Run
~/.local/bin/timemanagement ~/times.txt

# Or like this
runhaskell app/Main.hs  ~/times.txt
```

`times.txt` is a text file with lines of `hh:mm <project>`.

E.g. for this file:

```
> cat times.txt

08:46 Pause
10:02 Pause
10:02 stop
10:33 Project1: foo
13:17 Project1: foo
14:18 Pause
14:19 Project2: bar
14:21 Project2: bar
14:22 Pause
15:42 Project1: foo
```


```
> runhaskell app/Main.hs  ~/times.txt
("Pause",157)
("Project1: foo",225)
("Project2: bar",3)
("stop",31)
```


