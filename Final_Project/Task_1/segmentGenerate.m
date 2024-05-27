function segment = segmentGenerate(linkLen, ang1, ang2, ang3, ang4)

segment = [linkLen(1)*cos(ang1), linkLen(1)*sin(ang1);...
    linkLen(1)*cos(ang1)+linkLen(2)*cos(ang1+ang2), linkLen(1)*sin(ang1)+linkLen(2)*sin(ang1+ang2);...
    linkLen(1)*cos(ang1)+linkLen(2)*cos(ang1+ang2)+linkLen(3)*cos(ang1+ang2+ang3),...
    linkLen(1)*sin(ang1)+linkLen(2)*sin(ang1+ang2)+linkLen(3)*sin(ang1+ang2+ang3);...
    linkLen(1)*cos(ang1)+linkLen(2)*cos(ang1+ang2)+linkLen(3)*cos(ang1+ang2+ang3)+linkLen(4)*cos(ang1+ang2+ang3+ang4),...
    linkLen(1)*sin(ang1)+linkLen(2)*sin(ang1+ang2)+linkLen(3)*sin(ang1+ang2+ang3)+linkLen(4)*sin(ang1+ang2+ang3+ang4)];

end

