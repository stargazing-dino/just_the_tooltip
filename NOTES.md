I want to add a controller and an wrapper class. These two don't have to be exclusive:


```dart
return TooltipArea(
  builder: (
    BuildContext context,
    // This thing needs to know the existence of others...
    List<Widget> children,
  ) {
    return Stack(
      children: [
        TooltipWrapper(child: child),
        ...children,
      ],
    );
  },
);


class TooltipWrapper extends StatelessWidget {
    // ...
}
```

`TooltipArea` will have a context associated with it. When `TooltipWrapper` gets clicked, it will do a `context.of(TooltipAreaState)` and call close and whatever. It will also have optional bindings for `onClick`.

