# Generated from ENTITY.g4 by ANTLR 4.11.1
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
        4,1,6,35,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,1,0,5,0,12,8,0,
        10,0,12,0,15,9,0,1,0,1,0,1,1,1,1,5,1,21,8,1,10,1,12,1,24,9,1,1,1,
        1,1,1,2,1,2,1,2,1,3,1,3,1,4,1,4,1,4,0,0,5,0,2,4,6,8,0,0,31,0,13,
        1,0,0,0,2,18,1,0,0,0,4,27,1,0,0,0,6,30,1,0,0,0,8,32,1,0,0,0,10,12,
        3,2,1,0,11,10,1,0,0,0,12,15,1,0,0,0,13,11,1,0,0,0,13,14,1,0,0,0,
        14,16,1,0,0,0,15,13,1,0,0,0,16,17,5,0,0,1,17,1,1,0,0,0,18,22,5,1,
        0,0,19,21,3,4,2,0,20,19,1,0,0,0,21,24,1,0,0,0,22,20,1,0,0,0,22,23,
        1,0,0,0,23,25,1,0,0,0,24,22,1,0,0,0,25,26,5,2,0,0,26,3,1,0,0,0,27,
        28,3,6,3,0,28,29,3,8,4,0,29,5,1,0,0,0,30,31,5,3,0,0,31,7,1,0,0,0,
        32,33,5,3,0,0,33,9,1,0,0,0,2,13,22
    ]

class ENTITYParser ( Parser ):

    grammarFileName = "ENTITY.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'{'", "'}'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "QUOTED_STRING", 
                      "BLOCKCOMMENT", "LINECOMMENT", "WS" ]

    RULE_actors = 0
    RULE_block = 1
    RULE_pair = 2
    RULE_keyword = 3
    RULE_args = 4

    ruleNames =  [ "actors", "block", "pair", "keyword", "args" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    QUOTED_STRING=3
    BLOCKCOMMENT=4
    LINECOMMENT=5
    WS=6

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.11.1")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    class ActorsContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def EOF(self):
            return self.getToken(ENTITYParser.EOF, 0)

        def block(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(ENTITYParser.BlockContext)
            else:
                return self.getTypedRuleContext(ENTITYParser.BlockContext,i)


        def getRuleIndex(self):
            return ENTITYParser.RULE_actors

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterActors" ):
                listener.enterActors(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitActors" ):
                listener.exitActors(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitActors" ):
                return visitor.visitActors(self)
            else:
                return visitor.visitChildren(self)




    def actors(self):

        localctx = ENTITYParser.ActorsContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_actors)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 13
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==1:
                self.state = 10
                self.block()
                self.state = 15
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 16
            self.match(ENTITYParser.EOF)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class BlockContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def pair(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(ENTITYParser.PairContext)
            else:
                return self.getTypedRuleContext(ENTITYParser.PairContext,i)


        def getRuleIndex(self):
            return ENTITYParser.RULE_block

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterBlock" ):
                listener.enterBlock(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitBlock" ):
                listener.exitBlock(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitBlock" ):
                return visitor.visitBlock(self)
            else:
                return visitor.visitChildren(self)




    def block(self):

        localctx = ENTITYParser.BlockContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_block)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 18
            self.match(ENTITYParser.T__0)
            self.state = 22
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==3:
                self.state = 19
                self.pair()
                self.state = 24
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 25
            self.match(ENTITYParser.T__1)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PairContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def keyword(self):
            return self.getTypedRuleContext(ENTITYParser.KeywordContext,0)


        def args(self):
            return self.getTypedRuleContext(ENTITYParser.ArgsContext,0)


        def getRuleIndex(self):
            return ENTITYParser.RULE_pair

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPair" ):
                listener.enterPair(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPair" ):
                listener.exitPair(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPair" ):
                return visitor.visitPair(self)
            else:
                return visitor.visitChildren(self)




    def pair(self):

        localctx = ENTITYParser.PairContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_pair)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 27
            self.keyword()
            self.state = 28
            self.args()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class KeywordContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def QUOTED_STRING(self):
            return self.getToken(ENTITYParser.QUOTED_STRING, 0)

        def getRuleIndex(self):
            return ENTITYParser.RULE_keyword

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterKeyword" ):
                listener.enterKeyword(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitKeyword" ):
                listener.exitKeyword(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitKeyword" ):
                return visitor.visitKeyword(self)
            else:
                return visitor.visitChildren(self)




    def keyword(self):

        localctx = ENTITYParser.KeywordContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_keyword)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 30
            self.match(ENTITYParser.QUOTED_STRING)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ArgsContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def QUOTED_STRING(self):
            return self.getToken(ENTITYParser.QUOTED_STRING, 0)

        def getRuleIndex(self):
            return ENTITYParser.RULE_args

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterArgs" ):
                listener.enterArgs(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitArgs" ):
                listener.exitArgs(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitArgs" ):
                return visitor.visitArgs(self)
            else:
                return visitor.visitChildren(self)




    def args(self):

        localctx = ENTITYParser.ArgsContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_args)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 32
            self.match(ENTITYParser.QUOTED_STRING)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





