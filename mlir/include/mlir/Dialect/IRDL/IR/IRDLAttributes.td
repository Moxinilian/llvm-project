//===- IRDLAttributes.td - IR Definition Language Dialect --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the attributes used in IRDL.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_IRDL_IR_IRDLATTRIBUTES
#define MLIR_DIALECT_IRDL_IR_IRDLATTRIBUTES

include "IRDL.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"

class IRDL_Attr<string attrName, string attrMnemonic, list<Trait> traits = []>
    : AttrDef<IRDL_Dialect, attrName, traits> {
  let mnemonic = attrMnemonic;
}

def Variadicity : I32EnumAttr<
    "Variadicity", "variadicity kind",
    [
      I32EnumAttrCase<"single",  0>,
      I32EnumAttrCase<"optional",  1>,
      I32EnumAttrCase<"variadic", 2>,
    ]> {
  let cppNamespace = "::mlir::irdl";
  let genSpecializedAttr = 0;
}

def VariadicityAttr : EnumAttr<IRDL_Dialect, Variadicity, "variadicity"> {
  let summary =
    "A variadicity kind. Can be either 'single', 'optional', or 'variadic'";
  let description = [{
    A `irdl.variadicity` attribute specifies that the associated operand or
    result definition is either a single definition (the default), an
    optional definition, or a variadic definition.

    For instance:
    ```mlir
    irdl.operands (%arg1, single %arg2, optional %arg3, variadic %arg4)
    ```

    In this example, both %arg1 and %arg2 are single operands, %arg3 is an
    optional operand, and %arg4 is a variadic operand.
  }];
}

def VariadicityArrayAttr : ArrayOfAttr<IRDL_Dialect, "VariadicityArray", "variadicity_array",
                            VariadicityAttr.cppClassName> {}

def DialectItemAttr : IRDL_Attr<"DialectItem", "dialect_item", []> {
  let description = [{
    Targets a named item of a specific dialect (operation, type or attribute).

    The referred item must be defined in the same IR module as this attribute.
  }];
  let parameters = (ins
    "StringAttr":$dialect,
    "StringAttr":$item
  );
  let assemblyFormat = [{
    $dialect `->` $item
  }];
}

#endif // MLIR_DIALECT_IRDL_IR_IRDLATTRIBUTES
