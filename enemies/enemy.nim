import "../weapons/weapons"

type Enemy* = object
    hp: int
    weapon: Weapon
    armor: Armor


proc generateGoblin(): Enemy =
    return Enemy(
        hp: 15,
        weapon: getWeapon("sword"),
        armor: getArmor("leather")
    )


