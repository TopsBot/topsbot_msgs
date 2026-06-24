# topsbot_msgs

[中文文档](README_cn.md)

ROS 2 custom message repository for the TOPSBOT platform. This repo defines **interface types only** — no executable nodes.

## Packages

| Package | Documentation |
| ------- | ------------- |
| [tb_img_msgs](./tb_img_msgs/) | [README.md](./tb_img_msgs/README.md) · [README_cn.md](./tb_img_msgs/README_cn.md) |
| [tb_det_msgs](./tb_det_msgs/) | [README.md](./tb_det_msgs/README.md) · [README_cn.md](./tb_det_msgs/README_cn.md) |


## Repository layout

```
topsbot_msgs/
├── README.md / README_cn.md
├── tb_img_msgs/
└── tb_det_msgs/
```

## Build

### Dependencies

- ROS 2 Humble (or compatible distro)
- `rosidl_default_generators` / `rosidl_default_runtime`
- `builtin_interfaces`, `std_msgs`, `sensor_msgs` (`tb_det_msgs`)

### From source

Place this repo under your workspace `src/`, then:

```bash
colcon build --packages-select tb_img_msgs tb_det_msgs
source install/setup.bash
```


### apt 

```bash
sudo apt install -y ros-humble-tb-img-msgs ros-humble-tb-det-msgs
```



## Use in other packages

### package.xml

```xml
<depend>tb_img_msgs</depend>
<depend>tb_det_msgs</depend>  <!-- optional -->
```

### CMakeLists.txt

```cmake
find_package(tb_img_msgs REQUIRED)
find_package(tb_det_msgs REQUIRED)

ament_target_dependencies(your_node tb_img_msgs tb_det_msgs)
```

After adding a dependency, rebuild message packages and your node when `.msg` files change.

---

## License

Apache License 2.0 — see [LICENSE](./LICENSE) and [NOTICE](./NOTICE).

Contributions welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md).
