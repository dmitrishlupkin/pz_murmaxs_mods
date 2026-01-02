BWOTrespassRegistries = BWOTrespassRegistries or {}

print("[BWOTrespassRegistries] starting registering")
BWOTrespassRegistries.Registries = BWOTrespassRegistries.Registries or {}
BWOTrespassRegistries.Registries.MoodleTypes = BWOTrespassRegistries.Registries.MoodleTypes or {}
BWOTrespassRegistries.Registries.MoodleTypes.TRESPASSING = MoodleType.register("BWO:trespassing")
print("[BWOTrespassRegistries] BWO:trespassing registered")