/// A preset avatar animal shape, drawn by `PresetAvatarIcon` — an
/// alternative to uploading a real photo (`AppUser.photoBase64`) for users
/// who'd rather pick a simple animal + color than share a real picture.
enum PresetAnimal {
  cat,
  fish,
  bird,
  owl,
  bear,
  rabbit;

  static PresetAnimal? fromKey(String? key) => switch (key) {
        'cat' => PresetAnimal.cat,
        'fish' => PresetAnimal.fish,
        'bird' => PresetAnimal.bird,
        'owl' => PresetAnimal.owl,
        'bear' => PresetAnimal.bear,
        'rabbit' => PresetAnimal.rabbit,
        _ => null,
      };
}

abstract final class PresetAvatarConfig {
  static const List<PresetAnimal> animals = PresetAnimal.values;
}
