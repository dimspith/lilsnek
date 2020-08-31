# Lilsnek
### Overview

**Lilsnek** is a simple snake game for the average bored t`erminal user. It aims to be small and portable because nobody wants extra dependencies for something so simple.

**Warning: It is not yet complete so some bugs are still present and more features are to be added**

### Building from source

You need [Nim](https://nim-lang.org/) and [nimble](https://github.com/nim-lang/nimble) installed.

To generate a dynamic binary run:

`nimble build -d:release`

Alternatively for a static binary run:

`nimble build -d:release --passL:-static`