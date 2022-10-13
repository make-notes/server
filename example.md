**粗体**

_斜体_

++下划线++

~~删除线~~

==颜色==

# 标题

水平线

---

> 引用

- 无序列表

1. 有序列表

- [ ] todo 未完成
- [x] todo 已完成
- [超链接](https://note.youdao.com/)

![插入图片](https://note.youdao.com/favicon.ico)

`内嵌代码`

```
代码块
```

| 表头 1 | 表头 2 |
| ------ | ------ |
| 1      | 2      |

数学公式

```math
E = mc^2
```

化学公式

```math
\ce{SO4^2- + Ba^2+ -> BaSO4 v}
```

流程图

```
flowchart LR
    Start --> Stop
```

时序图

```
sequenceDiagram
    participant A as Alice
    participant J as John
    A->>J: Hello John, how are you?
    J->>A: Great!
```

甘特图

```
gantt
    title A Gantt Diagram
    dateFormat  YYYY-MM-DD
    section Section
    A task           :a1, 2014-01-01, 30d
    Another task     :after a1  , 20d
    section Another
    Task in sec      :2014-01-12  , 12d
    another task      : 24d
```

类图

```
classDiagram
Class01 <|-- AveryLongClass : Cool
Class03 *-- Class04
Class05 o-- Class06
Class07 .. Class08
Class01 : size()
Class01 : int chimp
Class01 : int gorilla
```

状态图

```
stateDiagram-v2
    state if_state <>
    [*] --> IsPositive
    IsPositive --> if_state
    if_state --> False: if n < 0
    if_state --> True : if n >= 0
```

E-R 图

```
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
```

饼图

```
pie
    title Key elements in Product X
    "Calcium" : 42.96
    "Potassium" : 50.05
    "Magnesium" : 10.01
    "Iron" :  5
```

用户旅程图

```
journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me
```
