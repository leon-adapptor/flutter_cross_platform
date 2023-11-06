import 'package:cross_platform/skeleton_item.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

const kDefaultArcheryTriggerOffset = 200.0;

class ArcheryPage extends StatefulWidget {
  const ArcheryPage({super.key});

  @override
  State<ArcheryPage> createState() => _ArcheryPageState();
}

class _ArcheryPageState extends State<ArcheryPage> {
  int _count = 2;
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        controller: _controller,
        header: const ArcheryHeader(
          position: IndicatorPosition.locator,
          processedDuration: Duration(seconds: 1),
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 0));
          if (!mounted) {
            return;
          }
          setState(() {
            _count++;
          });
          _controller.finishRefresh();
          _controller.resetFooter();
        },
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Shooting practice'),
              pinned: true,
            ),
            const HeaderLocator.sliver(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const SkeletonItem();
                },
                childCount: _count,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcheryHeader extends Header {
  const ArcheryHeader({
    super.clamping = false,
    super.triggerOffset = kDefaultArcheryTriggerOffset,
    super.position = IndicatorPosition.above,
    super.processedDuration = Duration.zero,
    super.springRebound = false,
    super.hapticFeedback = false,
    super.safeArea = false,
    super.spring,
    super.readySpringBuilder,
    super.frictionFactor,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _ArcheryIndicator(
      state: state,
      reverse: state.reverse,
    );
  }
}

class _ArcheryIndicator extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  const _ArcheryIndicator({
    required this.state,
    required this.reverse,
  });

  @override
  State<_ArcheryIndicator> createState() => _ArcheryIndicatorState();
}

class _ArcheryIndicatorState extends State<_ArcheryIndicator> {
  double get _offset => widget.state.offset;
  IndicatorMode get _mode => widget.state.mode;
  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  SMINumber? pull;
  SMITrigger? advance;
  StateMachineController? controller;

  @override
  void initState() {
    super.initState();
    widget.state.notifier.addModeChangeListener(_onModeChange);
    _loadRiveFile();
  }

  RiveFile? _riveFile;
  void _loadRiveFile() {
    rootBundle.load('assets/pull-to-refresh-use-case.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        setState(() {
          _riveFile = RiveFile.import(data);
        });
      },
    );
  }

  @override
  void dispose() {
    widget.state.notifier.removeModeChangeListener(_onModeChange);
    controller?.dispose();
    // _riveFile = null;
    super.dispose();
  }

  /// Mode change listener.
  void _onModeChange(IndicatorMode mode, double offset) {
    // print(mode);
    switch (mode) {
      case IndicatorMode.drag:
        controller?.isActive = true;
        break;
      case IndicatorMode.ready:
        advance?.fire();
        break;
      case IndicatorMode.processed:
        advance?.fire();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == IndicatorMode.drag || _mode == IndicatorMode.armed) {
      final percentage = (_offset / _actualTriggerOffset).clamp(0.0, 1.1) * 100;
      pull?.value = percentage;
    }
    return SizedBox(
      width: double.infinity,
      height: _offset,
      child: (_offset > 0 && _riveFile != null)
          ? RiveAnimation.direct(
              _riveFile!,
              artboard: 'Bullseye',
              fit: BoxFit.cover,
              onInit: (artboard) {
                controller = StateMachineController.fromArtboard(
                    artboard, 'numberSimulation')!;
                controller?.isActive = false;
                if (controller == null) {
                  throw Exception(
                      'Unable to initialize state machine controller');
                }
                artboard.addController(controller!);
                pull = controller!.findInput<double>('pull') as SMINumber;
                advance = controller!.findInput<bool>('advance') as SMITrigger;
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
