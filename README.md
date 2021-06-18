# just_the_tooltip

A package that is just the tooltip.

## Getting Started

install it

```yaml
    just_the_tooltip: <latest_version>
```

Tooltip can be set to prefer any axis but will try to fit in opposite axis if the space is not big enough. This tooltip sizes itself to fit the size of its child.

<p>  
 <img src="https://github.com/Nolence/just_the_tooltip/blob/main/screenshots/ezgif-2-3ef406bb2022.gif?raw=true"/>
</p>

```dart
JustTheTooltip(
  child: Material(
    color: Colors.grey.shade800,
    shape: const CircleBorder(),
    elevation: 4.0,
    child: const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    ),
  ),
  content: const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      'Bacon ipsum dolor amet kevin turducken brisket pastrami, salami ribeye spare ribs tri-tip sirloin shoulder venison shank burgdoggen chicken pork belly. Short loin filet mignon shoulder rump beef ribs meatball kevin.',
    ),
  ),
)
```

The child will be wrapped with a gesture detecor that is responsible for showing the content.

<p>  
 <img src="https://github.com/Nolence/just_the_tooltip/blob/main/screenshots/ezgif-2-f7d77a21f161.gif?raw=true"/>
</p>

The tooltip should also work in lists.