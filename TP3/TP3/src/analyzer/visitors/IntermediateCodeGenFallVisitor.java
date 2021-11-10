package analyzer.visitors;

import analyzer.SemantiqueError;
import analyzer.ast.*;
import com.sun.org.apache.xpath.internal.operations.Bool;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Vector;


/**
 * Created: 19-02-15
 * Last Changed: 20-10-6
 * Author: Félix Brunet & Doriane Olewicki
 * <p>
 * Description: Ce visiteur explore l'AST et génère un code intermédiaire.
 */

public class IntermediateCodeGenFallVisitor implements ParserVisitor {

    //le writer est un Output_Stream connecter au fichier "result". c'est donc ce qui permet de print dans les fichiers
    //le code généré.
    private final PrintWriter writer;

    public IntermediateCodeGenFallVisitor(PrintWriter writer) {
        this.writer = writer;
    }

    public HashMap<String, VarType> SymbolTable = new HashMap<>();

    private int id = 0;
    private int label = 0;

    /*
    génère une nouvelle variable temporaire qu'il est possible de print
    À noté qu'il serait possible de rentrer en conflit avec un nom de variable définit dans le programme.
    Par simplicité, dans ce tp, nous ne concidérerons pas cette possibilité, mais il faudrait un générateur de nom de
    variable beaucoup plus robuste dans un vrai compilateur.
     */
    private String genId() {
        return "_t" + id++;
    }

    //génère un nouveau Label qu'il est possible de print.
    private String genLabel() {
        return "_L" + label++;
    }

    @Override
    public Object visit(SimpleNode node, Object data) {
        return data;
    }

    @Override
    public Object visit(ASTProgram node, Object data) {
        String label = genLabel();
        node.childrenAccept(this, label);
        this.writer.println(label);
        return null;
    }

    /*
    Code fournis pour remplir la table de symbole.
    Les déclarations ne sont plus utile dans le code à trois adresse.
    elle ne sont donc pas concervé.
     */
    @Override
    public Object visit(ASTDeclaration node, Object data) {
        ASTIdentifier id = (ASTIdentifier) node.jjtGetChild(0);
        VarType t;
        if (node.getValue().equals("bool")) {
            t = VarType.Bool;
        } else {
            t = VarType.Number;
        }
        SymbolTable.put(id.getValue(), t);
        return null;
    }

    @Override
    public Object visit(ASTBlock node, Object data) {
        for (int i = 0; i < node.jjtGetNumChildren(); i++) {
            if (i + 1 == node.jjtGetNumChildren()) {
                node.jjtGetChild(i).jjtAccept(this, data);
                return null;
            }
            String newLabel = genLabel();
            node.jjtGetChild(i).jjtAccept(this, newLabel);
            this.writer.println(newLabel);
        }
        return null;
    }

    @Override
    public Object visit(ASTStmt node, Object data) {
        node.childrenAccept(this, data);
        return null;
    }

    @Override
    public Object visit(ASTForStmt node, Object data) {
        node.jjtGetChild(0).jjtAccept(this, data);
        String begin = genLabel();
        BoolLabel bl = new BoolLabel("fall", data.toString());
        this.writer.println(begin);
        node.jjtGetChild(1).jjtAccept(this, bl);
        node.jjtGetChild(3).jjtAccept(this, begin);
        node.jjtGetChild(2).jjtAccept(this, begin);
        this.writer.println("goto " + begin);
        return null;
    }

    /*
    le If Stmt doit vérifier s'il à trois enfants pour savoir s'il s'agit d'un "if-then" ou d'un "if-then-else".
     */
    @Override
    public Object visit(ASTIfStmt node, Object data) {
        BoolLabel child = new BoolLabel("", "");
        boolean isIfElseStmt = node.jjtGetNumChildren() > 2;

        if (isIfElseStmt) {
            child.lTrue = "fall";
            child.lFalse = genLabel();
            node.jjtGetChild(0).jjtAccept(this, child);
            node.jjtGetChild(1).jjtAccept(this, data);
            this.writer.println("goto " + data.toString());
            this.writer.println(child.lFalse);
            node.jjtGetChild(2).jjtAccept(this, data);
        } else {
            child.lTrue = "fall";
            child.lFalse = data.toString();
            node.jjtGetChild(0).jjtAccept(this, child);
            node.jjtGetChild(1).jjtAccept(this, data);
        }
        return null;
    }

    @Override
    public Object visit(ASTWhileStmt node, Object data) {
        String begin = genLabel();
        BoolLabel child = new BoolLabel("fall", data.toString());
        this.writer.println(begin);
        node.jjtGetChild(0).jjtAccept(this, child);
        node.jjtGetChild(1).jjtAccept(this, begin);
        this.writer.println("goto " + begin);
        return null;
    }

    @Override
    public Object visit(ASTAssignStmt node, Object data) {
        String firstChild = node.jjtGetChild(0).jjtAccept(this, null).toString();

        if (this.SymbolTable.containsKey(firstChild)
                && this.SymbolTable.get(firstChild) == VarType.Number) {
            String secondChild = node.jjtGetChild(1).jjtAccept(this, data).toString();
            this.writer.println(firstChild + " = " + secondChild);
        } else {
            BoolLabel bl = new BoolLabel("fall", genLabel());
            node.jjtGetChild(1).jjtAccept(this, bl);
            this.writer.println(firstChild + " = 1");
            this.writer.println("goto " + data.toString());
            this.writer.println(bl.lFalse);
            this.writer.println(firstChild + " = 0");
        }
        return null;
    }


    @Override
    public Object visit(ASTExpr node, Object data) {
        return node.jjtGetChild(0).jjtAccept(this, data);
    }

    //Expression arithmétique
    /*
    Les expressions arithmétique add et mult fonctionne exactement de la même manière. c'est pourquoi
    il est plus simple de remplir cette fonction une fois pour avoir le résultat pour les deux noeuds.

    On peut bouclé sur "ops" ou sur node.jjtGetNumChildren(),
    la taille de ops sera toujours 1 de moins que la taille de jjtGetNumChildren
     */
    public Object generateCodeForAddAndMultiplication(SimpleNode node, Object data, Vector<String> ops) {

        if (node.jjtGetNumChildren() > 1) {
            String temp = genId();
            String firstChild = node.jjtGetChild(0).jjtAccept(this, data).toString();
            String secondChild = node.jjtGetChild(1).jjtAccept(this, data).toString();
            this.writer.println(temp + " = " + firstChild + " " + ops.get(0) + " " + secondChild);
            return temp;
        } else return node.jjtGetChild(0).jjtAccept(this, data);
    }

    @Override
    public Object visit(ASTAddExpr node, Object data) {
        return generateCodeForAddAndMultiplication(node, data, node.getOps());
    }

    @Override
    public Object visit(ASTMulExpr node, Object data) {
        return generateCodeForAddAndMultiplication(node, data, node.getOps());
    }

    //UnaExpr est presque pareil au deux précédente. la plus grosse différence est qu'il ne va pas
    //chercher un deuxième noeud enfant pour avoir une valeur puisqu'il s'agit d'une opération unaire.
    @Override
    public Object visit(ASTUnaExpr node, Object data) {
        if (!node.getOps().isEmpty()) {
            String addr = node.jjtGetChild(0).jjtAccept(this, data).toString();
            for (int i = 0; i < node.getOps().size(); i++) {
                String nextUna = genId();
                this.writer.println(nextUna + " = - " + addr);
                addr = nextUna;
            }
            return addr;
        } else {
            return node.jjtGetChild(0).jjtAccept(this, data);
        }
    }

    //expression logique
    @Override
    public Object visit(ASTBoolExpr node, Object data) {
        if (node.getOps().size() >= 1) {
            BoolLabel parent = (BoolLabel) data;
            BoolLabel firstChild = new BoolLabel("", "");
            BoolLabel secondChild = new BoolLabel("", "");

            secondChild.lTrue = parent.lTrue;
            secondChild.lFalse = parent.lFalse;
            if ("&&".equals(node.getOps().get(0).toString())) {
                firstChild.lTrue = "fall";
                if ("fall".equals(parent.lFalse)) {
                    firstChild.lFalse = genLabel();
                } else {
                    firstChild.lFalse = parent.lFalse;
                }

                node.jjtGetChild(0).jjtAccept(this, firstChild);
                node.jjtGetChild(1).jjtAccept(this, secondChild);

                if ("fall".equals(parent.lFalse)) {
                    this.writer.println(firstChild.lFalse);
                }
            } else if ("||".equals(node.getOps().get(0).toString())) {
                firstChild.lFalse = "fall";
                if ("fall".equals(parent.lTrue)) {
                    firstChild.lTrue = genLabel();
                } else {
                    firstChild.lTrue = parent.lTrue;
                }

                node.jjtGetChild(0).jjtAccept(this, firstChild);
                node.jjtGetChild(1).jjtAccept(this, secondChild);
                if ("fall".equals(parent.lTrue)) {
                    this.writer.println(firstChild.lTrue);
                }
            }
            return data;
        } else
            return node.jjtGetChild(0).jjtAccept(this, data);
    }

    @Override
    public Object visit(ASTCompExpr node, Object data) {
        if (node.jjtGetNumChildren() > 1 && data instanceof BoolLabel) {
            BoolLabel parent = (BoolLabel) data;

            if (!"fall".equals(parent.lTrue) && !"fall".equals(parent.lFalse)) {
                String firstChild = node.jjtGetChild(0).jjtAccept(this, data).toString();
                String secondChild = node.jjtGetChild(1).jjtAccept(this, data).toString();
                this.writer.println("if " + firstChild + " " + node.getValue() + " " + secondChild + " goto " + parent.lTrue);
                this.writer.println("goto " + parent.lFalse);
            } else if (!"fall".equals(parent.lTrue) && "fall".equals(parent.lFalse)) {
                String firstChild = node.jjtGetChild(0).jjtAccept(this, data).toString();
                String secondChild = node.jjtGetChild(1).jjtAccept(this, data).toString();
                this.writer.println("if" + firstChild + " " + node.getValue() + " " + secondChild + " goto " + parent.lTrue);
            } else if ("fall".equals(parent.lTrue) && !"fall".equals(parent.lFalse)) {
                String firstChild = node.jjtGetChild(0).jjtAccept(this, data).toString();
                String secondChild = node.jjtGetChild(1).jjtAccept(this, data).toString();
                this.writer.println("ifFalse " + firstChild + " " + node.getValue() + " " + secondChild + " goto " + parent.lFalse);
            }
            return null;
        } else
            return node.jjtGetChild(0).jjtAccept(this, data);
    }


    /*
    Même si on peut y avoir un grand nombre d'opération, celle-ci s'annullent entre elle.
    il est donc intéressant de vérifier si le nombre d'opération est pair ou impaire.
    Si le nombre d'opération est pair, on peut simplement ignorer ce noeud.
     */
    @Override
    public Object visit(ASTNotExpr node, Object data) {
        if (node.getOps().size() % 2 == 1) {
            BoolLabel parent = (BoolLabel) data;
            BoolLabel child = new BoolLabel(parent.lFalse, parent.lTrue);
            node.jjtGetChild(0).jjtAccept(this, child);
            return null;
        }
        return node.jjtGetChild(0).jjtAccept(this, data);
    }

    @Override
    public Object visit(ASTGenValue node, Object data) {
        return node.jjtGetChild(0).jjtAccept(this, data).toString();
    }

    /*
    BoolValue ne peut pas simplement retourné sa valeur à son parent contrairement à GenValue et IntValue,
    Il doit plutôt généré des Goto direct, selon sa valeur.
     */
    @Override
    public Object visit(ASTBoolValue node, Object data) {
        BoolLabel parent = (BoolLabel) data;

        if (node.getValue()) {
            if (!"fall".equals(parent.lTrue)) {
                this.writer.println("goto " + parent.lTrue);
            }
        } else {
            if (!"fall".equals(parent.lFalse)) {
                this.writer.println("goto " + parent.lFalse);
            }
        }

        return node.getValue();
    }


    /*
    si le type de la variable est booléenne, il faudra généré des goto ici.
    le truc est de faire un "if value == 1 goto Label".
    en effet, la structure "if valeurBool goto Label" n'existe pas dans la syntaxe du code à trois adresse.
     */
    @Override
    public Object visit(ASTIdentifier node, Object data) {
        if (data == null) {
            return node.getValue();
        }

        VarType identifierType = this.SymbolTable.get(node.getValue());
        if (identifierType == VarType.Bool) {
            BoolLabel parent = (BoolLabel) data;
            if (!"fall".equals(parent.lTrue) && !"fall".equals(parent.lFalse)) {
                this.writer.println("if " + node.getValue() + " == 1 goto " + parent.lTrue);
                this.writer.println("goto " + parent.lFalse);
            } else if (!"fall".equals(parent.lTrue) && "fall".equals(parent.lFalse)) {
                this.writer.println("if " + node.getValue() + " == 1 goto " + parent.lTrue);
            } else if ("fall".equals(parent.lTrue) && !"fall".equals(parent.lFalse)) {
                this.writer.println("ifFalse " + node.getValue() + " == 1 goto " + parent.lFalse);
            }
        }

        return node.getValue();
    }

    @Override
    public Object visit(ASTIntValue node, Object data) {
        return node.getValue();
    }

    //des outils pour vous simplifier la vie et vous enligner dans le travail
    public enum VarType {
        Bool,
        Number
    }

    //utile surtout pour envoyé de l'informations au enfant des expressions logiques.
    private class BoolLabel {
        public String lTrue;
        public String lFalse;

        public BoolLabel(String t, String f) {
            lTrue = t;
            lFalse = f;
        }
    }


}
