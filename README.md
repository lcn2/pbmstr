# pbmstr

XXX


# To install

```sh
make clobber all
sudo make install clobber
```


# To use

```sh
/usr/local/bin/pbmstr [-h] [-v level] [-V] [-n] string ...
    [-c] [-o offset] arg ...

    -h            print help message and exit
    -v level      set verbosity level (def level: 0)
    -V            print version string and exit

    string ...	   string(s) as a line of text to convert to PBM image on stdout

pbmstr version: 1.2.1 2025-03-26
```


# Examples

```sh
/usr/local/bin/pbmstr 'chongo was here' > chongo.pbm
```

```sh
/usr/local/bin/pbmstr 'string 1' '2nd string' 'line3 string' 'the end' > foo.pbm
```


# Reporting Security Issues

To report a security issue, please visit "[Reporting Security Issues](https://github.com/lcn2/pbmstr/security/policy)".
