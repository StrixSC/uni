/* Generated By:JJTree: Do not edit this line. ASTWhileStmt.java Version 7.0 */
/* JavaCCOptions:MULTI=true,NODE_USES_PARSER=false,VISITOR=true,TRACK_TOKENS=false,NODE_PREFIX=AST,NODE_EXTENDS=,NODE_FACTORY=,SUPPORT_CLASS_VISIBILITY_PUBLIC=true */
package analyzer.ast;

public
class ASTWhileStmt extends SimpleNode {
  public ASTWhileStmt(int id) {
    super(id);
  }

  public ASTWhileStmt(Parser p, int id) {
    super(p, id);
  }


  /** Accept the visitor. **/
  public Object jjtAccept(ParserVisitor visitor, Object data) {

    return
    visitor.visit(this, data);
  }
}
/* JavaCC - OriginalChecksum=c70ba3c94d87d5dfdb10fcbccdb54b5f (do not edit this line) */
