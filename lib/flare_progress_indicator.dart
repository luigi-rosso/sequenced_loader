import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class FlareProgressIndicator extends StatefulWidget {
  final bool isLoading;
  final VoidCallback indicatedCompletion;
  FlareProgressIndicator(this.isLoading, {this.indicatedCompletion});

  @override
  _FlareProgressIndicatorState createState() => _FlareProgressIndicatorState();
}

class _FlareProgressIndicatorState extends State<FlareProgressIndicator>
    implements FlareController {
  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/SequencedLoader.flr",
      controller: this,
    );
  }

  ActorAnimation _loading, _complete;
  double _animationTime = 0.0;
  bool _completed = false;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _animationTime += elapsed;
    if (widget.isLoading) {
      // Still loading...
      _animationTime %= _loading.duration;
      _loading.apply(_animationTime, artboard, 1.0);
    } else if (_animationTime < _loading.duration) {
      // Complete, but need to finish loading animation...
      _loading.apply(_animationTime, artboard, 1.0);
    } else if(!_completed) {
      // Chain completion animation
      double completeTime = _animationTime - _loading.duration;
      _complete.apply(completeTime, artboard, 1.0);
      if (completeTime >= _complete.duration) {
        // Notify we're done and stop advancing.
        widget.indicatedCompletion();
		_completed = true;
        return false;
      }
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _loading = artboard.getAnimation("Loading");
    _complete = artboard.getAnimation("Complete");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
