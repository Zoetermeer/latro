@(^)(True, True)    = False
@(^)(False, False)  = False
@(^)(_, _)          = True

main(_) {
  IO.println(True ^ True)
  IO.println(False ^ True)
  IO.println( (^)(True, False) )
}
