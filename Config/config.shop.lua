Config = {}


Config.license = {
    license = "license-UKB.VehicleShop-160eff2b7f7e509c6e02dafcf7e4e72899c4a15834b8203c6eba62429f7a49a7",
}

Shop = {}
Shop.distance = 30
Shop.inventoryPath = "nui://esx_inventoryhud/html/img/items/"
Shop.Notify = {
    name = 'esx_textui',
    message = 'Press ~INPUT_CONTEXT~ to buy item',
}

Shop.Weight = false  

Shop.listShop = {
    ['ร้านค้าทั่วไป'] = {
        icon = "fas fa-store",
        item = {
            ['Food'] = {
                ['water'] = {max=10,price=100}
            },
            ['Tools']={
                ['fixkit'] = {max = 10 , price = 800},

            },
            ['Electronic']={
                ['phone'] = {max = 5 , price = 1500},
                ['radio'] = {max = 1 , price = 1500},
                
            },
            ['Other'] = {   
                ['speaker'] = {max = 1 , price = 1500},
                
            }
        },
        BlipsOpen = true,
        Pos = {
            {x = 302.73, y = -273.61, z = 54.17 , Distance = 2},
            {x = -318.79, y = -921.58, z = 31.6 , Distance = 2}, -- ร้านค้า การาจกลาง
        },
        job = {},
        DrawText3D = true,
        npc = {
            enable = true,
            model = "s_m_m_linecook",
            dict = "WORLD_HUMAN_CLIPBOARD", --https://alexguirre.github.io/animations-list/
            name = "เจ้าของร้านทั่วไป",
            heading = 344.4,
        }
    },
    ['ร้านค้าตำรวจ'] = {
        item = {
            ['tools']={
                ['fixkit'] = {max = 10 , price = 500},
                ['armor'] = {max = 10 , price = 150},
                ['painkiller'] = {max = 10 , price = 100},
            },
            ['electronic']={
                
            },
            ['foods'] ={
                ['water'] = {max = 3 , price = 3000},
            },
            ['other'] = {

            }
        },
        BlipsOpen = false,
		Pos = {
			{x=-324.712097, y=-919.767029, z=31.588257 , Distance = 2},
		},

        job = {"police"},
        DrawText3D = false,
        npc = {
            enable = true,
            model = "s_m_m_linecook",
            dict = "", --https://alexguirre.github.io/animations-list/
            name = "เจ้าของร้านตำรวจ",
        }
    }
}