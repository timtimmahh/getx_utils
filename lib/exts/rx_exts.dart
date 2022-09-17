import 'package:dartkt/dartkt.dart';
import 'package:get/get.dart';

extension RxPairExtension<F, S> on Pair<F, S> {
  RxPair<F, S> get obs => RxPair.from(this);
}

class RxPair<F, S> extends Rx<Pair<F, S>> {
  RxPair(F first, S second) : this.from(Pair.of(first, second));

  RxPair.from(Pair<F, S> initial) : super(initial);

  F get first => value.left;

  set first(F value) {
    if (value != this.value.left) this.value = Pair.of(value, this.value.right);
  }

  S get second => value.right;

  set second(S value) {
    if (value != this.value.right) this.value = Pair.of(this.value.left, value);
  }
}
