# just_the_tooltip

A package that is just the tooltip.

## Getting Started

install it

```yaml
    just_the_tooltip: <latest_version>
```

Tooltip can be set to prefer any axis but will try to fit in opposite axis if the space is not big enough. This tooltip sizes itself to fit the size of its child.

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
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut auctor mi. Ut eros orci, rhoncus in cursus ut, mollis vel velit. Curabitur in finibus massa. Sed posuere placerat lectus non finibus. Quisque ultricies aliquet felis, sit amet semper nisi tempor at. Integer auctor quam neque. Nulla mollis justo ac ex vulputate, in mollis sem fringilla.',
    ),
  ),
)
```

The child will be wrapped with a gesture detecor that is responsible for showing the content.