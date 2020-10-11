# Minetest Docker Server Image + lsqlite3

This server image is a fork of the official minetest server image.  
It has [LuaSQLite 3](https://github.com/LuaDist/lsqlite3) installed to work with mods like [sban](https://github.com/shivajiva101/sban)

    docker pull lejo/minetest-lsqlite3:ref

Use it like the default one by binding volumes to it:

    docker create -v /home/minetest/data/:/var/lib/minetest/ -v /home/minetest/conf/:/etc/minetest/ lejo/minetest-lsqlite3:ref

ref can be:

- latest/master
- stable-0.4
- stable-0.5
- 5.3.0
- 5.2.0
- 5.1.1
- 5.1.0
- 5.0.1
- 5.0.0
- 0.4.17.1
- 0.4.17
- 0.4.16

If you want any tag build just ask me and I will trigger the build.
