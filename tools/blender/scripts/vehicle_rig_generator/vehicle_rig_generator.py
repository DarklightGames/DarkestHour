import bpy

def create_vertex_group(mesh):
    # Create vertex groups for objects
    if mesh.type == 'MESH':
        vertices = [v for f in mesh.data.polygons for v in f.vertices]
        mesh.vertex_groups.clear()
        vertex_group = mesh.vertex_groups.new(name=mesh.name)
        vertex_group.add(vertices, 1.0, 'ADD')

def traverse_hierarchy(armature, parent_mesh, parent_bone, node):
    print('parent_bone: ' + str(parent_bone))
    if node.type == 'MESH':
        mesh = node
        create_vertex_group(mesh)
        # Select the armature
        bpy.ops.object.mode_set(mode='OBJECT')
        bpy.ops.object.select_all(action='DESELECT')
        armature.select = True
        bpy.context.scene.objects.active = armature
        # Create a bone for the armature and make it a child of the parent bone, if specified
        bpy.ops.object.mode_set(mode='EDIT')
        bone = armature.data.edit_bones.new(mesh.name)
        bone.head = mesh.location
        bone.tail = bone.head
        bone.tail.x += 1.0  # TODO: have the tail dependent on the forward vector
        if parent_bone is not None:
            try:
                print('parenting bone {} to {}'.format(bone.name, parent_bone))
                bone.parent = armature.data.edit_bones[parent_bone]
            except KeyError:
                pass
        child_meshes = filter(lambda x: x.type == 'MESH', mesh.children)
        for child in child_meshes:
            traverse_hierarchy(armature, mesh, bone.name, child)
        # TODO: join the meshes AFTER hierarchy is made!
        # Join the mesh to the parent mesh
        # if parent_mesh is not None:
        #     bpy.ops.object.mode_set(mode='OBJECT')
        #     bpy.ops.object.select_all(action='DESELECT')
        #     mesh.select = True
        #     parent_mesh.select = True
        #     bpy.context.scene.objects.active = parent_mesh
        #     print('Joining meshes ({} + {})'.format(mesh, parent_mesh))
        #     bpy.ops.object.join()

# get selected object, make sure it's an armature
armature = bpy.context.selected_objects[0] if len(bpy.context.selected_objects) > 0 else None
if armature is None or armature.type != 'ARMATURE':
    raise Exception('Must select a single armature')

bpy.ops.object.mode_set(mode='EDIT')

for child in armature.children:
    traverse_hierarchy(armature, None, None, child)