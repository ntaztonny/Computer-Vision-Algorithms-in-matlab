function display_face_fac_vert_tex0(faces, vertices,texture, fpos,poscamZ)
% Use : display_face_fac_vert_tex(faces, vertices,texture, fpos,poscamZ)
% Inputs :
% *faces : gives the 3 numbering of the vertices that create faces (Nfx3)
% *vertices : XYZ of each vertices (Nvx3)
% *texture : RGB of each vertices (Nvx3)
% *fpos : raw vector , fpos(1) is the width of the displayed window , fpos(2) is the height of the displayed window
% *poscamZ : camera position (<0)

set(gcf, 'Renderer', 'opengl');
fig_pos = get(gcf, 'Position');
fig_pos(3) = fpos(1);%rp.width
fig_pos(4) = fpos(2);%rp.height
set(gcf, 'Position', fig_pos);
set(gcf, 'Resize', 'off');

mesh_h = trimesh(...
    faces, vertices(:, 1), vertices(:, 2), vertices(:, 3), ...
    'EdgeColor', 'none', ...
    'FaceVertexCData', texture/255, 'FaceColor', 'interp', ...
    'FaceLighting', 'phong' ...
    );


set(gca,'DataAspectRatio',[ 1 1 1 ],'Units','pixels','Position',[ 0 0 fig_pos(3) fig_pos(4) ],...
      'Visible','off','Box','off','Projection','perspective','CameraPosition',[0 0 poscamZ],...
      'CameraTarget',[0 0 1],'CameraUpVector',[0 1 0]);
% ax = gca;
% ax.DataAspectRatio=[ 1 1 1 ];%     'PlotBoxAspectRatio', [ 1 1 1 ], ...
% ax.Units='pixels';
% ax.Position=[ 0 0 fig_pos(3) fig_pos(4) ];
% ax.Visible='off';
% ax.Box='off';
% ax.Projection='perspective';
% ax.CameraPosition=[0 0 poscamZ];
% ax.CameraTarget=[0 0 1];
% ax.CameraUpVector=[0 1 0];
xlabel('x');ylabel('y');zlabel('z');

fx=gcf;
fx.Color=[ 0 0 0 ];

set(gcf,'Color',[ 0 0 0 ])
% material([.5, .5, .1 1  ])
% camlight('headlight');

