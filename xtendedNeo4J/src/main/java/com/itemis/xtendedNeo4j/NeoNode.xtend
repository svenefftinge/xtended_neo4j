package com.itemis.xtendedNeo4j

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.neo4j.graphdb.Node

@Active(NeoNodeProcessor)
@Target(ElementType.TYPE)
annotation NeoNode {
}

class NeoNodeProcessor extends AbstractClassProcessor {

  override doTransform(MutableClassDeclaration annotatedClass, extension TransformationContext context) {
    val nodeType = Node.newTypeReference
    val declaredFields = annotatedClass.declaredFields
    
    annotatedClass.addField("underlyingNode") [
      type = nodeType
    ]
    
    annotatedClass.addConstructor[
      addParameter("node", nodeType)
      body =  ['''
        this.underlyingNode = node;
      ''']
    ]
    
    annotatedClass.addMethod("getUnderlyingNode") [
      returnType = nodeType
      body = ['''
        return this.underlyingNode;
      ''']
    ]
    
    for (field : declaredFields) {
      annotatedClass.addMethod("get"+field.simpleName.toFirstUpper) [
        returnType = field.type
        body = ['''
          return («field.type.simpleName»)underlyingNode.getProperty("«field.simpleName»");
        ''']
      ]
      
      annotatedClass.addMethod("set"+field.simpleName.toFirstUpper) [
        addParameter(field.simpleName, field.type)
        body = ['''
          underlyingNode.setProperty("«field.simpleName»", «field.simpleName»);
        ''']
      ]
    }
    
    annotatedClass.addMethod("hashCode") [
      returnType = primitiveInt
      body = ['''
        return this.underlyingNode.hashCode();
      ''']
    ]
    
    annotatedClass.addMethod("equals") [
      returnType = primitiveBoolean
      addParameter("o", object)
      body = ['''
        return o instanceof «annotatedClass.simpleName» && 
            underlyingNode.equals( ( («annotatedClass.simpleName»)o ).getUnderlyingNode() );
      ''']
    ]
    
    annotatedClass.addMethod("toString") [
      returnType = string
      body = ['''
        return "«annotatedClass.simpleName»[«declaredFields.map[simpleName+':"+get'+simpleName.toFirstUpper+"()+"].join('",')»"]";
      ''']
    ]
    
    declaredFields.forEach[remove]
  }
}