# strings2csv

A simple CLI to convert Xcode strings files to CSV

## Usage

```bash
strings2csv <path to main strings file> [<lang1> <lang2> ...]
```

E.g.

```bash
strings2csv ~/myproject/Resources/en.lsproj/Localizable.strings es ca ja
```

The CSV is generated in the stdout.
