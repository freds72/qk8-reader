# Generated from FGD.g4 by ANTLR 4.11.1
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,17,166,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,1,0,5,0,34,8,0,10,0,12,0,37,9,0,1,0,1,0,1,1,
        1,1,1,1,5,1,44,8,1,10,1,12,1,47,9,1,1,1,1,1,1,1,1,1,3,1,53,8,1,1,
        1,1,1,1,2,1,2,1,3,1,3,1,3,1,3,1,3,5,3,64,8,3,10,3,12,3,67,9,3,1,
        3,1,3,1,3,5,3,72,8,3,10,3,12,3,75,9,3,1,3,1,3,5,3,79,8,3,10,3,12,
        3,82,9,3,1,3,3,3,85,8,3,1,3,1,3,1,4,1,4,1,5,1,5,1,5,1,5,1,6,1,6,
        1,7,1,7,1,7,5,7,100,8,7,10,7,12,7,103,9,7,1,8,1,8,5,8,107,8,8,10,
        8,12,8,110,9,8,1,8,1,8,1,9,1,9,1,9,1,9,1,10,1,10,1,10,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,132,8,10,1,10,
        1,10,1,10,5,10,137,8,10,10,10,12,10,140,9,10,1,10,3,10,143,8,10,
        1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,3,11,156,
        8,11,1,12,1,12,1,13,1,13,1,14,1,14,1,15,1,15,1,15,0,0,16,0,2,4,6,
        8,10,12,14,16,18,20,22,24,26,28,30,0,2,1,0,12,14,1,0,12,13,166,0,
        35,1,0,0,0,2,40,1,0,0,0,4,56,1,0,0,0,6,58,1,0,0,0,8,88,1,0,0,0,10,
        90,1,0,0,0,12,94,1,0,0,0,14,96,1,0,0,0,16,104,1,0,0,0,18,113,1,0,
        0,0,20,117,1,0,0,0,22,144,1,0,0,0,24,157,1,0,0,0,26,159,1,0,0,0,
        28,161,1,0,0,0,30,163,1,0,0,0,32,34,3,2,1,0,33,32,1,0,0,0,34,37,
        1,0,0,0,35,33,1,0,0,0,35,36,1,0,0,0,36,38,1,0,0,0,37,35,1,0,0,0,
        38,39,5,0,0,1,39,1,1,0,0,0,40,41,5,1,0,0,41,45,3,4,2,0,42,44,3,6,
        3,0,43,42,1,0,0,0,44,47,1,0,0,0,45,43,1,0,0,0,45,46,1,0,0,0,46,48,
        1,0,0,0,47,45,1,0,0,0,48,49,5,2,0,0,49,52,3,12,6,0,50,51,5,3,0,0,
        51,53,3,14,7,0,52,50,1,0,0,0,52,53,1,0,0,0,53,54,1,0,0,0,54,55,3,
        16,8,0,55,3,1,0,0,0,56,57,5,14,0,0,57,5,1,0,0,0,58,59,5,14,0,0,59,
        84,5,4,0,0,60,65,3,10,5,0,61,62,5,5,0,0,62,64,3,10,5,0,63,61,1,0,
        0,0,64,67,1,0,0,0,65,63,1,0,0,0,65,66,1,0,0,0,66,85,1,0,0,0,67,65,
        1,0,0,0,68,73,3,8,4,0,69,70,5,5,0,0,70,72,3,8,4,0,71,69,1,0,0,0,
        72,75,1,0,0,0,73,71,1,0,0,0,73,74,1,0,0,0,74,85,1,0,0,0,75,73,1,
        0,0,0,76,80,5,6,0,0,77,79,3,18,9,0,78,77,1,0,0,0,79,82,1,0,0,0,80,
        78,1,0,0,0,80,81,1,0,0,0,81,83,1,0,0,0,82,80,1,0,0,0,83,85,5,7,0,
        0,84,60,1,0,0,0,84,68,1,0,0,0,84,76,1,0,0,0,85,86,1,0,0,0,86,87,
        5,8,0,0,87,7,1,0,0,0,88,89,7,0,0,0,89,9,1,0,0,0,90,91,5,12,0,0,91,
        92,5,12,0,0,92,93,5,12,0,0,93,11,1,0,0,0,94,95,5,14,0,0,95,13,1,
        0,0,0,96,101,5,13,0,0,97,98,5,9,0,0,98,100,5,13,0,0,99,97,1,0,0,
        0,100,103,1,0,0,0,101,99,1,0,0,0,101,102,1,0,0,0,102,15,1,0,0,0,
        103,101,1,0,0,0,104,108,5,10,0,0,105,107,3,20,10,0,106,105,1,0,0,
        0,107,110,1,0,0,0,108,106,1,0,0,0,108,109,1,0,0,0,109,111,1,0,0,
        0,110,108,1,0,0,0,111,112,5,11,0,0,112,17,1,0,0,0,113,114,5,13,0,
        0,114,115,5,3,0,0,115,116,3,28,14,0,116,19,1,0,0,0,117,118,3,26,
        13,0,118,119,5,4,0,0,119,120,3,24,12,0,120,131,5,8,0,0,121,122,5,
        3,0,0,122,123,5,3,0,0,123,132,3,28,14,0,124,125,5,3,0,0,125,126,
        3,14,7,0,126,127,5,3,0,0,127,128,3,28,14,0,128,132,1,0,0,0,129,130,
        5,3,0,0,130,132,3,14,7,0,131,121,1,0,0,0,131,124,1,0,0,0,131,129,
        1,0,0,0,131,132,1,0,0,0,132,142,1,0,0,0,133,134,5,2,0,0,134,138,
        5,10,0,0,135,137,3,22,11,0,136,135,1,0,0,0,137,140,1,0,0,0,138,136,
        1,0,0,0,138,139,1,0,0,0,139,141,1,0,0,0,140,138,1,0,0,0,141,143,
        5,11,0,0,142,133,1,0,0,0,142,143,1,0,0,0,143,21,1,0,0,0,144,155,
        3,30,15,0,145,146,5,3,0,0,146,147,5,3,0,0,147,156,3,28,14,0,148,
        149,5,3,0,0,149,150,3,14,7,0,150,151,5,3,0,0,151,152,3,28,14,0,152,
        156,1,0,0,0,153,154,5,3,0,0,154,156,3,14,7,0,155,145,1,0,0,0,155,
        148,1,0,0,0,155,153,1,0,0,0,156,23,1,0,0,0,157,158,5,14,0,0,158,
        25,1,0,0,0,159,160,5,14,0,0,160,27,1,0,0,0,161,162,7,1,0,0,162,29,
        1,0,0,0,163,164,7,1,0,0,164,31,1,0,0,0,13,35,45,52,65,73,80,84,101,
        108,131,138,142,155
    ]

class FGDParser ( Parser ):

    grammarFileName = "FGD.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "'='", "':'", "'('", "','", "'{'", 
                     "'}'", "')'", "'+'", "'['", "']'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "NUMBER", "QUOTED_STRING", "KEYWORD", "BLOCKCOMMENT", 
                      "LINECOMMENT", "WS" ]

    RULE_blocks = 0
    RULE_classdef = 1
    RULE_classtype = 2
    RULE_classattribute = 3
    RULE_attributeproperty = 4
    RULE_vectorproperty = 5
    RULE_classname = 6
    RULE_tooltip = 7
    RULE_classprops = 8
    RULE_untypedproperty = 9
    RULE_typedproperty = 10
    RULE_option = 11
    RULE_valuetype = 12
    RULE_propertyname = 13
    RULE_value = 14
    RULE_optionkey = 15

    ruleNames =  [ "blocks", "classdef", "classtype", "classattribute", 
                   "attributeproperty", "vectorproperty", "classname", "tooltip", 
                   "classprops", "untypedproperty", "typedproperty", "option", 
                   "valuetype", "propertyname", "value", "optionkey" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    T__4=5
    T__5=6
    T__6=7
    T__7=8
    T__8=9
    T__9=10
    T__10=11
    NUMBER=12
    QUOTED_STRING=13
    KEYWORD=14
    BLOCKCOMMENT=15
    LINECOMMENT=16
    WS=17

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.11.1")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    class BlocksContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def EOF(self):
            return self.getToken(FGDParser.EOF, 0)

        def classdef(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.ClassdefContext)
            else:
                return self.getTypedRuleContext(FGDParser.ClassdefContext,i)


        def getRuleIndex(self):
            return FGDParser.RULE_blocks

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterBlocks" ):
                listener.enterBlocks(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitBlocks" ):
                listener.exitBlocks(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitBlocks" ):
                return visitor.visitBlocks(self)
            else:
                return visitor.visitChildren(self)




    def blocks(self):

        localctx = FGDParser.BlocksContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_blocks)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 35
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==1:
                self.state = 32
                self.classdef()
                self.state = 37
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 38
            self.match(FGDParser.EOF)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ClassdefContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def classtype(self):
            return self.getTypedRuleContext(FGDParser.ClasstypeContext,0)


        def classname(self):
            return self.getTypedRuleContext(FGDParser.ClassnameContext,0)


        def classprops(self):
            return self.getTypedRuleContext(FGDParser.ClasspropsContext,0)


        def classattribute(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.ClassattributeContext)
            else:
                return self.getTypedRuleContext(FGDParser.ClassattributeContext,i)


        def tooltip(self):
            return self.getTypedRuleContext(FGDParser.TooltipContext,0)


        def getRuleIndex(self):
            return FGDParser.RULE_classdef

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterClassdef" ):
                listener.enterClassdef(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitClassdef" ):
                listener.exitClassdef(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitClassdef" ):
                return visitor.visitClassdef(self)
            else:
                return visitor.visitChildren(self)




    def classdef(self):

        localctx = FGDParser.ClassdefContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_classdef)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 40
            self.match(FGDParser.T__0)
            self.state = 41
            self.classtype()
            self.state = 45
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==14:
                self.state = 42
                self.classattribute()
                self.state = 47
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 48
            self.match(FGDParser.T__1)
            self.state = 49
            self.classname()
            self.state = 52
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==3:
                self.state = 50
                self.match(FGDParser.T__2)
                self.state = 51
                self.tooltip()


            self.state = 54
            self.classprops()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ClasstypeContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_classtype

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterClasstype" ):
                listener.enterClasstype(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitClasstype" ):
                listener.exitClasstype(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitClasstype" ):
                return visitor.visitClasstype(self)
            else:
                return visitor.visitChildren(self)




    def classtype(self):

        localctx = FGDParser.ClasstypeContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_classtype)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 56
            self.match(FGDParser.KEYWORD)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ClassattributeContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def vectorproperty(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.VectorpropertyContext)
            else:
                return self.getTypedRuleContext(FGDParser.VectorpropertyContext,i)


        def attributeproperty(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.AttributepropertyContext)
            else:
                return self.getTypedRuleContext(FGDParser.AttributepropertyContext,i)


        def untypedproperty(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.UntypedpropertyContext)
            else:
                return self.getTypedRuleContext(FGDParser.UntypedpropertyContext,i)


        def getRuleIndex(self):
            return FGDParser.RULE_classattribute

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterClassattribute" ):
                listener.enterClassattribute(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitClassattribute" ):
                listener.exitClassattribute(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitClassattribute" ):
                return visitor.visitClassattribute(self)
            else:
                return visitor.visitChildren(self)




    def classattribute(self):

        localctx = FGDParser.ClassattributeContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_classattribute)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 58
            self.match(FGDParser.KEYWORD)
            self.state = 59
            self.match(FGDParser.T__3)
            self.state = 84
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.state = 60
                self.vectorproperty()
                self.state = 65
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                while _la==5:
                    self.state = 61
                    self.match(FGDParser.T__4)
                    self.state = 62
                    self.vectorproperty()
                    self.state = 67
                    self._errHandler.sync(self)
                    _la = self._input.LA(1)

                pass

            elif la_ == 2:
                self.state = 68
                self.attributeproperty()
                self.state = 73
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                while _la==5:
                    self.state = 69
                    self.match(FGDParser.T__4)
                    self.state = 70
                    self.attributeproperty()
                    self.state = 75
                    self._errHandler.sync(self)
                    _la = self._input.LA(1)

                pass

            elif la_ == 3:
                self.state = 76
                self.match(FGDParser.T__5)
                self.state = 80
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                while _la==13:
                    self.state = 77
                    self.untypedproperty()
                    self.state = 82
                    self._errHandler.sync(self)
                    _la = self._input.LA(1)

                self.state = 83
                self.match(FGDParser.T__6)
                pass


            self.state = 86
            self.match(FGDParser.T__7)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class AttributepropertyContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def NUMBER(self):
            return self.getToken(FGDParser.NUMBER, 0)

        def QUOTED_STRING(self):
            return self.getToken(FGDParser.QUOTED_STRING, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_attributeproperty

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterAttributeproperty" ):
                listener.enterAttributeproperty(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitAttributeproperty" ):
                listener.exitAttributeproperty(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitAttributeproperty" ):
                return visitor.visitAttributeproperty(self)
            else:
                return visitor.visitChildren(self)




    def attributeproperty(self):

        localctx = FGDParser.AttributepropertyContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_attributeproperty)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 88
            _la = self._input.LA(1)
            if not(((_la) & ~0x3f) == 0 and ((1 << _la) & 28672) != 0):
                self._errHandler.recoverInline(self)
            else:
                self._errHandler.reportMatch(self)
                self.consume()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class VectorpropertyContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NUMBER(self, i:int=None):
            if i is None:
                return self.getTokens(FGDParser.NUMBER)
            else:
                return self.getToken(FGDParser.NUMBER, i)

        def getRuleIndex(self):
            return FGDParser.RULE_vectorproperty

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterVectorproperty" ):
                listener.enterVectorproperty(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitVectorproperty" ):
                listener.exitVectorproperty(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitVectorproperty" ):
                return visitor.visitVectorproperty(self)
            else:
                return visitor.visitChildren(self)




    def vectorproperty(self):

        localctx = FGDParser.VectorpropertyContext(self, self._ctx, self.state)
        self.enterRule(localctx, 10, self.RULE_vectorproperty)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 90
            self.match(FGDParser.NUMBER)
            self.state = 91
            self.match(FGDParser.NUMBER)
            self.state = 92
            self.match(FGDParser.NUMBER)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ClassnameContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_classname

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterClassname" ):
                listener.enterClassname(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitClassname" ):
                listener.exitClassname(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitClassname" ):
                return visitor.visitClassname(self)
            else:
                return visitor.visitChildren(self)




    def classname(self):

        localctx = FGDParser.ClassnameContext(self, self._ctx, self.state)
        self.enterRule(localctx, 12, self.RULE_classname)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 94
            self.match(FGDParser.KEYWORD)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class TooltipContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def QUOTED_STRING(self, i:int=None):
            if i is None:
                return self.getTokens(FGDParser.QUOTED_STRING)
            else:
                return self.getToken(FGDParser.QUOTED_STRING, i)

        def getRuleIndex(self):
            return FGDParser.RULE_tooltip

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTooltip" ):
                listener.enterTooltip(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTooltip" ):
                listener.exitTooltip(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitTooltip" ):
                return visitor.visitTooltip(self)
            else:
                return visitor.visitChildren(self)




    def tooltip(self):

        localctx = FGDParser.TooltipContext(self, self._ctx, self.state)
        self.enterRule(localctx, 14, self.RULE_tooltip)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 96
            self.match(FGDParser.QUOTED_STRING)
            self.state = 101
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==9:
                self.state = 97
                self.match(FGDParser.T__8)
                self.state = 98
                self.match(FGDParser.QUOTED_STRING)
                self.state = 103
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ClasspropsContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def typedproperty(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.TypedpropertyContext)
            else:
                return self.getTypedRuleContext(FGDParser.TypedpropertyContext,i)


        def getRuleIndex(self):
            return FGDParser.RULE_classprops

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterClassprops" ):
                listener.enterClassprops(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitClassprops" ):
                listener.exitClassprops(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitClassprops" ):
                return visitor.visitClassprops(self)
            else:
                return visitor.visitChildren(self)




    def classprops(self):

        localctx = FGDParser.ClasspropsContext(self, self._ctx, self.state)
        self.enterRule(localctx, 16, self.RULE_classprops)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 104
            self.match(FGDParser.T__9)
            self.state = 108
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==14:
                self.state = 105
                self.typedproperty()
                self.state = 110
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 111
            self.match(FGDParser.T__10)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class UntypedpropertyContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def QUOTED_STRING(self):
            return self.getToken(FGDParser.QUOTED_STRING, 0)

        def value(self):
            return self.getTypedRuleContext(FGDParser.ValueContext,0)


        def getRuleIndex(self):
            return FGDParser.RULE_untypedproperty

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterUntypedproperty" ):
                listener.enterUntypedproperty(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitUntypedproperty" ):
                listener.exitUntypedproperty(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitUntypedproperty" ):
                return visitor.visitUntypedproperty(self)
            else:
                return visitor.visitChildren(self)




    def untypedproperty(self):

        localctx = FGDParser.UntypedpropertyContext(self, self._ctx, self.state)
        self.enterRule(localctx, 18, self.RULE_untypedproperty)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 113
            self.match(FGDParser.QUOTED_STRING)
            self.state = 114
            self.match(FGDParser.T__2)
            self.state = 115
            self.value()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class TypedpropertyContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def propertyname(self):
            return self.getTypedRuleContext(FGDParser.PropertynameContext,0)


        def valuetype(self):
            return self.getTypedRuleContext(FGDParser.ValuetypeContext,0)


        def value(self):
            return self.getTypedRuleContext(FGDParser.ValueContext,0)


        def tooltip(self):
            return self.getTypedRuleContext(FGDParser.TooltipContext,0)


        def option(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(FGDParser.OptionContext)
            else:
                return self.getTypedRuleContext(FGDParser.OptionContext,i)


        def getRuleIndex(self):
            return FGDParser.RULE_typedproperty

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTypedproperty" ):
                listener.enterTypedproperty(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTypedproperty" ):
                listener.exitTypedproperty(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitTypedproperty" ):
                return visitor.visitTypedproperty(self)
            else:
                return visitor.visitChildren(self)




    def typedproperty(self):

        localctx = FGDParser.TypedpropertyContext(self, self._ctx, self.state)
        self.enterRule(localctx, 20, self.RULE_typedproperty)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 117
            self.propertyname()
            self.state = 118
            self.match(FGDParser.T__3)
            self.state = 119
            self.valuetype()
            self.state = 120
            self.match(FGDParser.T__7)
            self.state = 131
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.state = 121
                self.match(FGDParser.T__2)
                self.state = 122
                self.match(FGDParser.T__2)
                self.state = 123
                self.value()

            elif la_ == 2:
                self.state = 124
                self.match(FGDParser.T__2)
                self.state = 125
                self.tooltip()
                self.state = 126
                self.match(FGDParser.T__2)
                self.state = 127
                self.value()

            elif la_ == 3:
                self.state = 129
                self.match(FGDParser.T__2)
                self.state = 130
                self.tooltip()


            self.state = 142
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==2:
                self.state = 133
                self.match(FGDParser.T__1)
                self.state = 134
                self.match(FGDParser.T__9)
                self.state = 138
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                while _la==12 or _la==13:
                    self.state = 135
                    self.option()
                    self.state = 140
                    self._errHandler.sync(self)
                    _la = self._input.LA(1)

                self.state = 141
                self.match(FGDParser.T__10)


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class OptionContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def optionkey(self):
            return self.getTypedRuleContext(FGDParser.OptionkeyContext,0)


        def value(self):
            return self.getTypedRuleContext(FGDParser.ValueContext,0)


        def tooltip(self):
            return self.getTypedRuleContext(FGDParser.TooltipContext,0)


        def getRuleIndex(self):
            return FGDParser.RULE_option

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterOption" ):
                listener.enterOption(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitOption" ):
                listener.exitOption(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitOption" ):
                return visitor.visitOption(self)
            else:
                return visitor.visitChildren(self)




    def option(self):

        localctx = FGDParser.OptionContext(self, self._ctx, self.state)
        self.enterRule(localctx, 22, self.RULE_option)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 144
            self.optionkey()
            self.state = 155
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.state = 145
                self.match(FGDParser.T__2)
                self.state = 146
                self.match(FGDParser.T__2)
                self.state = 147
                self.value()
                pass

            elif la_ == 2:
                self.state = 148
                self.match(FGDParser.T__2)
                self.state = 149
                self.tooltip()
                self.state = 150
                self.match(FGDParser.T__2)
                self.state = 151
                self.value()
                pass

            elif la_ == 3:
                self.state = 153
                self.match(FGDParser.T__2)
                self.state = 154
                self.tooltip()
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ValuetypeContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_valuetype

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterValuetype" ):
                listener.enterValuetype(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitValuetype" ):
                listener.exitValuetype(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitValuetype" ):
                return visitor.visitValuetype(self)
            else:
                return visitor.visitChildren(self)




    def valuetype(self):

        localctx = FGDParser.ValuetypeContext(self, self._ctx, self.state)
        self.enterRule(localctx, 24, self.RULE_valuetype)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 157
            self.match(FGDParser.KEYWORD)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PropertynameContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def KEYWORD(self):
            return self.getToken(FGDParser.KEYWORD, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_propertyname

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPropertyname" ):
                listener.enterPropertyname(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPropertyname" ):
                listener.exitPropertyname(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPropertyname" ):
                return visitor.visitPropertyname(self)
            else:
                return visitor.visitChildren(self)




    def propertyname(self):

        localctx = FGDParser.PropertynameContext(self, self._ctx, self.state)
        self.enterRule(localctx, 26, self.RULE_propertyname)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 159
            self.match(FGDParser.KEYWORD)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ValueContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NUMBER(self):
            return self.getToken(FGDParser.NUMBER, 0)

        def QUOTED_STRING(self):
            return self.getToken(FGDParser.QUOTED_STRING, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_value

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterValue" ):
                listener.enterValue(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitValue" ):
                listener.exitValue(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitValue" ):
                return visitor.visitValue(self)
            else:
                return visitor.visitChildren(self)




    def value(self):

        localctx = FGDParser.ValueContext(self, self._ctx, self.state)
        self.enterRule(localctx, 28, self.RULE_value)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 161
            _la = self._input.LA(1)
            if not(_la==12 or _la==13):
                self._errHandler.recoverInline(self)
            else:
                self._errHandler.reportMatch(self)
                self.consume()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class OptionkeyContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NUMBER(self):
            return self.getToken(FGDParser.NUMBER, 0)

        def QUOTED_STRING(self):
            return self.getToken(FGDParser.QUOTED_STRING, 0)

        def getRuleIndex(self):
            return FGDParser.RULE_optionkey

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterOptionkey" ):
                listener.enterOptionkey(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitOptionkey" ):
                listener.exitOptionkey(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitOptionkey" ):
                return visitor.visitOptionkey(self)
            else:
                return visitor.visitChildren(self)




    def optionkey(self):

        localctx = FGDParser.OptionkeyContext(self, self._ctx, self.state)
        self.enterRule(localctx, 30, self.RULE_optionkey)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 163
            _la = self._input.LA(1)
            if not(_la==12 or _la==13):
                self._errHandler.recoverInline(self)
            else:
                self._errHandler.reportMatch(self)
                self.consume()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





