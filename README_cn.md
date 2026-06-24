# topsbot_msgs

[English](README.md)

TOPSBOT 平台的 **ROS 2 自定义消息仓库**，集中维护板端感知链路所需的接口定义。本仓库**不包含可执行节点**，仅提供消息类型供其他功能包依赖。

## 子包

| 子包 | 文档 |
| ---- | ---- |
| [tb_img_msgs](./tb_img_msgs/) | [README.md](./tb_img_msgs/README.md) · [README_cn.md](./tb_img_msgs/README_cn.md) |
| [tb_det_msgs](./tb_det_msgs/) | [README.md](./tb_det_msgs/README.md) · [README_cn.md](./tb_det_msgs/README_cn.md) |

各子包 README 中有消息定义、字段说明、使用示例与常见问题，此处不再重复。

## 仓库结构

```
topsbot_msgs/
├── README.md / README_cn.md
├── tb_img_msgs/
└── tb_det_msgs/
```

## 安装与编译

### 依赖

- ROS 2 Humble（或兼容的 ROS 2 发行版）
- `rosidl_default_generators` / `rosidl_default_runtime`
- `builtin_interfaces`、`std_msgs`、`sensor_msgs`（`tb_det_msgs` 需要）

### 源码编译

将本仓库放入工作空间 `src/` 后：

```bash
colcon build --packages-select tb_img_msgs tb_det_msgs
source install/setup.bash
```


### apt 安装

```bash
sudo apt install -y ros-humble-tb-img-msgs ros-humble-tb-det-msgs
```


## 在其他包中使用

### package.xml

```xml
<depend>tb_img_msgs</depend>
<!-- 若需要检测结果消息 -->
<depend>tb_det_msgs</depend>
```

### CMakeLists.txt

```cmake
find_package(tb_img_msgs REQUIRED)
find_package(tb_det_msgs REQUIRED)  # 可选

ament_target_dependencies(your_node tb_img_msgs tb_det_msgs)
```

修改 `.msg` 文件后，需重新编译消息包及所有依赖它的功能包。

---

## 许可

Apache License 2.0 — 见 [LICENSE](./LICENSE) 与 [NOTICE](./NOTICE)。

欢迎贡献，请参阅 [CONTRIBUTING.md](./CONTRIBUTING.md)。
