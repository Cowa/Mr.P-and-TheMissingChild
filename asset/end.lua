return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.16.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 8,
  height = 8,
  tilewidth = 8,
  tileheight = 8,
  nextobjectid = 15,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "imagelayer",
      name = "bg",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      image = "end.png",
      properties = {}
    },
    {
      type = "objectgroup",
      name = "player",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 5,
          y = 30,
          width = 5,
          height = 5,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "baby",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3,
          y = 32,
          width = 3,
          height = 3,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "algae",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 4,
          name = "",
          type = "small-top",
          shape = "rectangle",
          x = 57,
          y = 46,
          width = 2,
          height = 2,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "collision",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0.375,
          y = 35.375,
          width = 12.375,
          height = 2.25,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 13.125,
          y = 36.25,
          width = 5.625,
          height = 1.75,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 19.375,
          y = 37.375,
          width = 11.25,
          height = 2,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 31.375,
          y = 38.25,
          width = 10.125,
          height = 1.75,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 41.875,
          y = 40.375,
          width = 2.875,
          height = 1.25,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 44.875,
          y = 42,
          width = 4.875,
          height = 2.5,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 50.25,
          y = 43.75,
          width = 2.375,
          height = 2.75,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 52.875,
          y = 46.875,
          width = 3.125,
          height = 2.625,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 56,
          y = 50,
          width = 6.75,
          height = 3.5,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
