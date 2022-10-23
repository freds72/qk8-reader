## Q8K SDK

### Pre-requisites

+ Pico 8 0.2.5+
+ Python 3.9+
+ (optional) local env
+ Python dependencies

```
pip install antlr4-python3-runtime
pip install tqdm
pip install pillow
```

+ Trenchbroom
+ Copy tools/q8k.fgd file to ```%appdata%\Trenchbroom\games\q8k\```
> note: colormap and palette lump files are located in repo in ```id1\gfx```

### How to generate PICO archive

+ Compile map (will generate bsp file)
+ Generate Pico8 carts:

```
cd tools
python .\wad_reader.py --mod-path ..\id1 --map <map name> --pico-home <pico path> --carts-path ..\carts
```

>Example:

```
python .\wad_reader.py --mod-path ..\id1 --map q8k_start --pico-home D:\pico-8_0.2.5 --carts-path ..\carts
```
+ start up cart is: q8k.p8


