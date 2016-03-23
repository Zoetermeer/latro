(* No namespaces for now *)

type id = string
type typename =
  | Id of id
  | Array of typename

type fun_proto = FunProto of typename * id * (ty list) * ty
and ty =
  | StructTy of field_def list
  | InterfaceTy of fun_proto list
  | FunTy of typename * (typename list) * typename

type param = Param of typename * id

type exp =
  | NumLit of int
  | Ref of id
  | Module of def list
and def =
  | Let of id * exp
  | FunDef of (typename list) * id * (param list) * typename * exp
  | TypeDef of id * (id list) * typename

type value =
  | ValueNum of int
  | ValueModule


let rec get id = function
  | [] -> failwith (sprintf "Id '%s' not in the environment!" id)
  | (x, v)::xs ->
    if id = x then v
    else get id xs


let rec _interp env = function
  | NumLit i -> i
  | Ref id -> _interp env (get id env)
  | Module defs ->
    _interp_defs defs

let interp = _interp []
