package analyzer.visitors;

import analyzer.SemantiqueError;
import analyzer.ast.*;

import javax.lang.model.element.VariableElement;
import javax.xml.crypto.Data;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created: 19-01-10
 * Last Changed: 21-09-28
 * Author: Esther Guerrier
 * <p>
 * Description: Ce visiteur explorer l'AST est renvois des erreur lorqu'une erreur sémantique est détecté.
 */

public class SemantiqueVisitor implements ParserVisitor {

    private final PrintWriter writer;

    private HashMap<String, VarType> symbolTable = new HashMap<>(); // mapping variable -> type

    // variable pour les metrics
    private int VAR = 0;
    private int WHILE = 0;
    private int IF = 0;
    private int FOR = 0;
    private int OP = 0;

    final String VARIABLE_ALREADY_EXISTS_ERROR = "Invalid declaration... variable %s already exists";
    final String UNDEFINED_ERROR = "Invalid use of undefined Identifier %s";
    final String ARRAY_TYPE_INCOMPATIBLE_ERROR = "Array type %s is incompatible with declared variable of type %s...";
    final String INVALID_CONDITION_TYPE_ERROR = "Invalid type in condition";
    final String INVALID_EXPRESSION_TYPE_ERROR = "Invalid type in expression";
    final String INVALID_ASSIGNMENT_TYPE_ERROR = "Invalid type in assignation of Identifier %s... was expecting %s but got %s";

    public SemantiqueVisitor(PrintWriter writer) {
        this.writer = writer;
    }

    /*
    Le Visiteur doit lancer des erreurs lorsqu'un situation arrive.

    regardez l'énoncé ou les tests pour voir le message à afficher et dans quelle situation.
    Lorsque vous voulez afficher une erreur, utilisez la méthode print implémentée ci-dessous.
    Tous vos tests doivent passer!!

     */

    @Override
    public Object visit(SimpleNode node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTProgram node, Object data) {
        node.childrenAccept(this, data);
        writer.print(String.format("{VAR:%d, WHILE:%d, IF:%d, FOR:%d, OP:%d}", VAR, WHILE, IF, FOR, OP));

        return null;
    }

    /*
    Ici se retrouve les noeuds servant à déclarer une variable.
    Certaines doivent enregistrer les variables avec leur type dans la table symbolique.
     */
    @Override
    public Object visit(ASTDeclaration node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTNormalDeclaration node, Object data) {
        String nodeValue = ((ASTIdentifier) node.jjtGetChild(0)).getValue();

        if (this.symbolTable.containsKey(nodeValue)) {
            throw new SemantiqueError(String.format(this.VARIABLE_ALREADY_EXISTS_ERROR, nodeValue));
        }

        symbolTable.put(nodeValue, node.getValue().equals("num") ? VarType.num : VarType.bool);
        VAR++;
        return null;
    }

    @Override
    public Object visit(ASTListDeclaration node, Object data) {
        // Check if variable exists in symbol table:
        String nodeValue = ((ASTIdentifier) node.jjtGetChild(0)).getValue();
        if (this.symbolTable.containsKey(nodeValue)) {
            throw new SemantiqueError(String.format(this.VARIABLE_ALREADY_EXISTS_ERROR, nodeValue));
        }

        // Variable doesn't exist, add it to the symbol table:
        symbolTable.put(nodeValue, node.getValue().equals("listnum") ? VarType.listnum : VarType.listbool);
        this.VAR++;
        return null;
    }

    @Override
    public Object visit(ASTBlock node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }


    @Override
    public Object visit(ASTStmt node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }

    /*
     * Il faut vérifier que le type déclaré à gauche soit compatible avec la liste utilisée à droite. N'oubliez pas
     * de vérifier que les variables existent.
     */

    @Override
    public Object visit(ASTForEachStmt node, Object data) {
        // Check if variable exists in symbol table:
        String listVariable = ((ASTIdentifier) node.jjtGetChild(1)).getValue();
        if (!this.symbolTable.containsKey(listVariable))
            throw new SemantiqueError(String.format(this.UNDEFINED_ERROR, listVariable));

        // Variable exists in symbol table, check if iterator type matches the declared array type:
        String iteratorVariableType = ((ASTNormalDeclaration) node.jjtGetChild(0)).getValue();
        VarType listVariableType = this.symbolTable.get(listVariable);
        if (!(iteratorVariableType.equals(listVariableType.name()))) {
            throw new SemantiqueError(String.format(this.ARRAY_TYPE_INCOMPATIBLE_ERROR, listVariableType.name(), iteratorVariableType));
        }

        this.FOR++;
        return null;
    }

    /*
    Ici faites attention!! Lisez la grammaire, c'est votre meilleur ami :)
    */
    @Override
    public Object visit(ASTForStmt node, Object data) {
        this.FOR++;
        return null;
    }

    /*
    Méthode recommandée à implémenter puisque vous remarquerez que quelques fonctions ont exactement le même code! N'oubliez
    -pas que la qualité du code est évalué :)
     */
    private void callChildenCond(SimpleNode node) {
        // Condition node contains the Expression & Block. First child is the expression.
        // Accept the first child and evaluate that the type of the expression is boolean by storing the type in ds
        DataStruct ds = new DataStruct();
        node.jjtGetChild(0).jjtAccept(this, ds);
        if (ds.type != VarType.bool)
            throw new SemantiqueError(this.INVALID_CONDITION_TYPE_ERROR);
        for (int i = 1; i < node.jjtGetNumChildren(); ++i) {
            node.jjtGetChild(i).jjtAccept(this, ds);
        }
    }

    /*
        les structures conditionnelle doivent vérifier que leur expression de condition est de type booléenne
        On doit aussi compter les conditions dans les variables IF et WHILE
    */
    @Override
    public Object visit(ASTIfStmt node, Object data) {
        this.callChildenCond(node);
        this.IF++;
        return null;
    }

    @Override
    public Object visit(ASTWhileStmt node, Object data) {
        this.callChildenCond(node);
        this.WHILE++;
        return null;
    }

    /*
    On doit vérifier que le type de la variable est compatible avec celui de l'expression.
    La variable doit etre déclarée.
     */
    @Override
    public Object visit(ASTAssignStmt node, Object data) {
        String identifierName = ((ASTIdentifier) node.jjtGetChild(0)).getValue();

        // Check if variable exists in the symbol table
        if (!this.symbolTable.containsKey(identifierName))
            throw new SemantiqueError(String.format(this.UNDEFINED_ERROR, identifierName));

        // Variable exists in the symbol table; check for type mismatch:
        VarType identifierType = this.symbolTable.get(identifierName);
        DataStruct ds = new DataStruct();
        node.jjtGetChild(1).jjtAccept(this, ds);
        if (ds.type != identifierType)
            throw new SemantiqueError(
                    String.format(this.INVALID_ASSIGNMENT_TYPE_ERROR, identifierName, identifierType, ds.type)
            );

        node.childrenAccept(this, ds);
        return null;
    }

    @Override
    public Object visit(ASTExpr node, Object data) {
        //Il est normal que tous les noeuds jusqu'à expr retourne un type.
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTCompExpr node, Object data) {
        /*attention, ce noeud est plus complexe que les autres.*/

        /* si il a plus d'un enfant, alors ils s'agit d'une comparaison. il a donc pour type "Bool".
        de plus, il n'est pas acceptable de faire des comparaisons de booleen avec les opérateur < > <= >=.
        les opérateurs == et != peuvent être utilisé pour les nombres et les booléens, mais il faut que le type soit le même
        des deux côté de l'égalité/l'inégalité.
        */

        int childrenCount = node.jjtGetNumChildren();

        /* si il n'a qu'un seul enfant, le noeud a pour type le type de son enfant. */
        if (childrenCount == 1) {
            node.childrenAccept(this, data);
            return null;
        }

        // The comparision has two child. We must
        // Get all the children types:
        ArrayList<VarType> childrenTypes = new ArrayList<>();
        DataStruct ds = new DataStruct();
        for (int i = 0; i < childrenCount; ++i) {
            node.jjtGetChild(i).jjtAccept(this, ds);
            childrenTypes.add(ds.type);
        }

        // 1. Make sure there is no type mismatch
        VarType commonType = childrenTypes.get(0);
        childrenTypes.forEach((type) -> {
            if (commonType != type)
                throw new SemantiqueError(this.INVALID_EXPRESSION_TYPE_ERROR);
        });

        // 2. Make sure that if the operation is <, >, <= or >=, the types of both children are num (it cant be bool)
        if (commonType.equals(VarType.bool)) {
            String operator = node.getValue();
            if (!(operator.equals("==") || operator.equals("!=")))
                throw new SemantiqueError(this.INVALID_EXPRESSION_TYPE_ERROR);
        }

        this.OP++;
        return null;
    }

    private void callChildren(SimpleNode node, Object data, VarType validType) {
        int childrenCount = node.jjtGetNumChildren();

        if (childrenCount == 1) {
            ((DataStruct) data).type = validType;
            node.childrenAccept(this, data);
            return;
        }

        DataStruct ds = new DataStruct();
        for (int i = 0; i < childrenCount; i++) {
            node.jjtGetChild(i).jjtAccept(this, ds);
            if (ds.type != validType)
                throw new SemantiqueError(INVALID_EXPRESSION_TYPE_ERROR);
        }
        this.OP++;
        ((DataStruct) data).type = validType;
    }

    /*
    opérateur binaire
    si il n'y a qu'un enfant, aucune vérifica[[[[[[tion à faire.
    par exemple, un AddExpr peut retourné le type "Bool" à condition de n'avoir qu'un seul enfant.
     */
    @Override
    public Object visit(ASTAddExpr node, Object data) {
        if (node.getOps().isEmpty())
            node.childrenAccept(this, data);
        else
            this.callChildren(node, data, VarType.num);
        return null;
    }

    @Override
    public Object visit(ASTMulExpr node, Object data) {
        if (node.getOps().isEmpty())
            node.childrenAccept(this, data);
        else
            this.callChildren(node, data, VarType.num);
        return null;
    }

    @Override
    public Object visit(ASTBoolExpr node, Object data) {
        if (node.getOps().isEmpty())
            node.childrenAccept(this, data);
        else
            this.callChildren(node, data, VarType.bool);
        return null;
    }

    /*
    opérateur unaire
    les opérateur unaire ont toujours un seul enfant.
    Cependant, ASTNotExpr et ASTUnaExpr ont la fonction "getOps()" qui retourne un vecteur contenant l'image (représentation str)
    de chaque token associé au noeud.
    Il est utile de vérifier la longueur de ce vecteur pour savoir si une opérande est présente.
    si il n'y a pas d'opérande, ne rien faire.
    si il y a une (ou plus) opérande, ils faut vérifier le type.
    */
    @Override
    public Object visit(ASTNotExpr node, Object data) {
        boolean hasOps = node.getOps().isEmpty();
        if(!hasOps)
            this.checkOpsTypes(node, VarType.bool);
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTUnaExpr node, Object data) {
        boolean hasOps = node.getOps().isEmpty();
        if(!hasOps)
            this.checkOpsTypes(node, VarType.num);
        node.childrenAccept(this, data);
        return null;
    }

    /*
    les noeud ASTIdentifier aillant comme parent "GenValue" doivent vérifier leur type et vérifier leur existence.

    Ont peut envoyé une information a un enfant avec le 2e paramètre de jjtAccept ou childrenAccept.
     */
    @Override
    public Object visit(ASTGenValue node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }


    @Override
    public Object visit(ASTBoolValue node, Object data) {
        ((DataStruct) data).type = VarType.bool;
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTIdentifier node, Object data) {
        String nodeValue = node.getValue();
        if (!this.symbolTable.containsKey(nodeValue))
            throw new SemantiqueError(String.format(this.UNDEFINED_ERROR, nodeValue));

        if (node.jjtGetParent() instanceof ASTGenValue) {
            ((DataStruct) data).type = this.symbolTable.get(node.getValue());
        }

        return null;
    }

    @Override
    public Object visit(ASTIntValue node, Object data) {
        ((DataStruct) data).type = VarType.num;
        node.childrenAccept(this, data);
        return null;
    }

    //des outils pour vous simplifier la vie et vous enligner dans le travail
    public enum VarType {
        bool,
        num,
        listnum,
        listbool
    }

    public void checkOpsTypes(SimpleNode node, VarType type) {
        DataStruct ds = new DataStruct();
        node.jjtGetChild(0).jjtAccept(this, ds);
        if (ds.type != type)
            throw new SemantiqueError(INVALID_EXPRESSION_TYPE_ERROR);
    }

    private class DataStruct {
        public VarType type;

        public DataStruct() {
        }

        public DataStruct(VarType p_type) {
            type = p_type;
        }
    }
}
