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

The child will be wrapped with a gesture detector that is responsible for showing the content.

<p>  
 <img src="https://github.com/Nolence/just_the_tooltip/blob/main/screenshots/ezgif-2-f7d77a21f161.gif?raw=true"/>
</p>

The tooltip should also work in lists and follow the target through scrolling.

For some use cases where the tooltip must be a part the widget tree rather than an overlay there is a `JustTheTooltipArea`:

```dart
Scaffold(
  appBar: AppBar(title: const Text('It goes under me')),
  body: JustTheTooltipArea(
    builder: (context, tooltip, scrim) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              if (index == 15) {
                return JustTheTooltipEntry(
                  tailLength: 10.0,
                  preferredDirection: AxisDirection.down,
                  margin: const EdgeInsets.all(20.0),
                  child: const Material(
                    color: Colors.blue,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.touch_app,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 120,
                        color: Colors.blue,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quia ducimus eius magni voluptatibus ut veniam ducimus. Ullam ab qui voluptatibus quos est in. Maiores eos ab magni tempora praesentium libero. Voluptate architecto rerum vel sapiente ducimus aut cumque quibusdam. Consequatur illo et quos vel cupiditate quis dolores at.',
                      ),
                    ],
                  ),
                );
              }

              return ListTile(title: Text('Item $index'));
            },
          ),
          if (scrim != null) scrim,
          if (tooltip != null) tooltip,
        ],
      );
    },
  ),
);
```

This will give you the positioned tooltip and scrim (an empty gesture detector that catches tap events and closes the tooltip) for you to enter into the tree however you like. By doing this, you can make tooltips that are visually "under" other parts of the UI such as the appbar in the above example.

Notice the use of `JustTheTooltipEntry`. It replaces the traditional widget as it no longer is in charge of the animation itself but delegates it to the parent widget area.

Issues and PRs welcome. API subject to change