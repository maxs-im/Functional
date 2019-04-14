# LAB №2 (variant 1): **Incomplete solution**

## Aim

Using Haskell (ghc with –threaded key), create a multi-threaded application:

### Task

Implement a multi-threaded version of the compression of multiple files into one archive using a Huffman algorithm. Show the efficiency of your algorithm (in time) on a multiprocessor system.

Original text: _Реализовать многопоточную версию сжатия множества файлов в один архив, используя алгоритм Хаффмана. Показать эффективность вашего алгоритма (по времени) на многопроцессорной системе._

## How to start

This "solution" for Windows. You should have WinRar and ghc compiler:

```bash
:: Add folder with winrar.exe to your PATH variable

ghc -o slow code.hs
ghc -o fast code.hs -threaded

```

Then you can run each executable file (slow || fast) with "1" or else argument.

* "1" - arg means that you want to encode (create zip)

## Author & Links

- **Maxim Galchenko** (@maxs-im)

[Batch Timer](https://stackoverflow.com/a/6209392)
[WinRar archiver](https://rarlab.com/)

[Github Repository](maxs-im/Functional/tree/master/lab_2)