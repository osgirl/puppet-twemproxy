class twemproxy::join(
  $members = undef
){

  $active = redis_ready($members, 5)

}
