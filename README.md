# Minetest Docker Server Image + lsqlite3

This server image is a fork of the official minetest server image.  
It has [LuaSQLite 3](https://github.com/LuaDist/lsqlite3) installed to work with mods like [sban](https://github.com/shivajiva101/sban)

`docker pull lejo/minetest-lsqlite3`

Use it like the default one by binding volumes to it:
`docker create -v /home/minetest/data/:/var/lib/minetest/ -v /home/minetest/conf/:/etc/minetest/ lejo/minetest-lsqlite3`
