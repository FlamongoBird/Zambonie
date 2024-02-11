import "../colors/color"
import tables


const colors* = {
    "great-fg" : color([0, 255, 0]),
    "good-fg" : color([0, 255, 0]),
    "neutral-fg" : color([0, 0, 255]),
    "bad-fg" : color([255, 0, 0]),
    "terrible-fg" : color([255, 0, 0]),
    "great-bg" : color([0, 255, 0], true),
    "good-bg" : color([0, 255, 0], true),
    "neutral-bg" : color([0, 0, 255], true),
    "bad-bg" : color([255, 0, 0], true),
    "terrible-bg" : color([255, 0, 0], true),
}.toTable